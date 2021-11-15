Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E55451146
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243724AbhKOTDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243372AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DA66348B;
        Mon, 15 Nov 2021 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999944;
        bh=QBD9JJqHPm96uNtYkyOlr8zGcgDrHZ4J2r+gFkAYoqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gm+KuU7yVZ650oj7Ey0J9doln/Q4FJAGGAab2czL2a/Y0iIE41Z2HaGHBj1GnbvAH
         93vcUGcwn9HfyldaoOAGtc0jMI8EQcEljqChKDt7eNd5A+USS84By1ByBk+OlgANqA
         FFM3hqLJ9e2m1EuwzDXq0lut8/qsQVNXG1CCcf6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 480/849] iwlwifi: pnvm: read EFI data only if long enough
Date:   Mon, 15 Nov 2021 17:59:23 +0100
Message-Id: <20211115165436.521395179@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e864a77f51d0d8113b49cf7d030bc9dc911c8176 ]

If the data we get from EFI is not even long enough for
the package struct we expect then ignore it entirely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: a1a6a4cf49ec ("iwlwifi: pnvm: implement reading PNVM from UEFI")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20211016114029.33feba783518.I54a5cf33975d0330792b3d208b225d479e168f32@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 512c512eefc71..24de6e5eb6a4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -284,9 +284,13 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 	/* First attempt to get the PNVM from BIOS */
 	package = iwl_uefi_get_pnvm(trans, &len);
 	if (!IS_ERR_OR_NULL(package)) {
-		/* we need only the data */
-		len -= sizeof(*package);
-		data = kmemdup(package->data, len, GFP_KERNEL);
+		if (len >= sizeof(*package)) {
+			/* we need only the data */
+			len -= sizeof(*package);
+			data = kmemdup(package->data, len, GFP_KERNEL);
+		} else {
+			data = NULL;
+		}
 
 		/* free package regardless of whether kmemdup succeeded */
 		kfree(package);
-- 
2.33.0



