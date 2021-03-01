Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111D2328A3D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhCASNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239376AbhCASIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A067652C8;
        Mon,  1 Mar 2021 17:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620263;
        bh=i6DqtohnSG93V8qjGFRzDDfp1BEoPLbkdhUEhWNOBHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f44BdOKlcFaYzWIE0hNQ2i8fZ2wmlHtrGK4dcDNPXGXvqC6g7EGkyXDssCg8ZjH51
         BZg+w2Y5nbjA02/y3wi3kp81x3HqkjlawOeTWPfzS76a/+0TY+MqpS+RKNDpImw4Yw
         opix7qGVS/W63/gYY4Rs6wBw+h5bdTIszPFJvGgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 089/775] iwlwifi: mvm: fix the type we use in the PPAG table validity checks
Date:   Mon,  1 Mar 2021 17:04:17 +0100
Message-Id: <20210301161206.080386879@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 5a6842455c113920001df83cffa28accceeb0927 ]

The value we receive from ACPI is a long long unsigned integer but the
values should be treated as signed char.  When comparing the received
value with ACPI_PPAG_MIN_LB/HB, we were doing an unsigned comparison,
so the negative value would actually be treated as a very high number.

To solve this issue, assign the value to our table of s8's before
making the comparison, so the value is already converted when we do
so.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210135352.b0ec69f312bc.If77fd9c61a96aa7ef2ac96d935b7efd7df502399@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 9e150c01f7b37..522d547f35d58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -962,16 +962,23 @@ read_table:
 			union acpi_object *ent;
 
 			ent = &wifi_pkg->package.elements[idx++];
-			if (ent->type != ACPI_TYPE_INTEGER ||
-			    (j == 0 && ent->integer.value > ACPI_PPAG_MAX_LB) ||
-			    (j == 0 && ent->integer.value < ACPI_PPAG_MIN_LB) ||
-			    (j != 0 && ent->integer.value > ACPI_PPAG_MAX_HB) ||
-			    (j != 0 && ent->integer.value < ACPI_PPAG_MIN_HB)) {
-				ppag_table.v1.enabled = cpu_to_le32(0);
+			if (ent->type != ACPI_TYPE_INTEGER) {
 				ret = -EINVAL;
 				goto out_free;
 			}
+
 			gain[i * num_sub_bands + j] = ent->integer.value;
+
+			if ((j == 0 &&
+			     (gain[i * num_sub_bands + j] > ACPI_PPAG_MAX_LB ||
+			      gain[i * num_sub_bands + j] < ACPI_PPAG_MIN_LB)) ||
+			    (j != 0 &&
+			     (gain[i * num_sub_bands + j] > ACPI_PPAG_MAX_HB ||
+			      gain[i * num_sub_bands + j] < ACPI_PPAG_MIN_HB))) {
+				ppag_table.v1.enabled = cpu_to_le32(0);
+				ret = -EINVAL;
+				goto out_free;
+			}
 		}
 	}
 	ret = 0;
-- 
2.27.0



