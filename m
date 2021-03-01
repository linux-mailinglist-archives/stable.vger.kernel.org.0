Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0B3328AD5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbhCASXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239538AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C002F65170;
        Mon,  1 Mar 2021 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618439;
        bh=jgQB9RKeyETS68Ouoc8IcaY3KHOjwFBmuV6WbgHdndU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptdPQI2Yx21BMQM7Mnga3Hm94dhG1unvFcv8xmnqbp8wp+TvwHLjsVp5b9n9LJOKE
         ZDlke4N29WvoNSMT+AyV/R42Gug4V+iERP99ircIIuQFJuJNev0MJCEiznD+98ObeS
         Jj0fOD4wIttVsfJAUHnFrbitTLPdEJV1gBSiBHDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/663] iwlwifi: mvm: fix the type we use in the PPAG table validity checks
Date:   Mon,  1 Mar 2021 17:05:35 +0100
Message-Id: <20210301161146.034824949@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 059ce227151ea..c351c91a9ec96 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -999,16 +999,23 @@ read_table:
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



