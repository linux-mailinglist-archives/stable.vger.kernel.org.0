Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A76B451136
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbhKOTCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243370AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94CAE6349C;
        Mon, 15 Nov 2021 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999941;
        bh=eeE7YKGLFIIpBIPGahhySBmfxdToAcGGozneXINEMkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FudX+qsxVaNkY4kMXeTKvbSZ7u1VdUpWhrIfVNX6A1DOgQ/3GzyOFtKzZuYnrbQcE
         pMKmmM541MTf97pFAwf7hCLQ5Kq6pEJGqx183BSRoWPVTRlOFnOeRUjSILI6//qz+E
         C5LsR9HlXBMytl2+E+AQgIE35BVcyZzdzIt/lSCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 479/849] iwlwifi: pnvm: dont kmemdup() more than we have
Date:   Mon, 15 Nov 2021 17:59:22 +0100
Message-Id: <20211115165436.488341324@linuxfoundation.org>
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

[ Upstream commit 0f892441d8c353144e3669b7991fa5fe0bd353e9 ]

We shouldn't kmemdup() more data than we have, that might
cause the code to crash. Fix that by updating the length
before the kmemdup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20211016114029.ab0e64c3fba9.Ic6a3295fc384750b51b4270bf0b7d94984a139f2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 513f9e5387290..512c512eefc71 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -284,16 +284,15 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 	/* First attempt to get the PNVM from BIOS */
 	package = iwl_uefi_get_pnvm(trans, &len);
 	if (!IS_ERR_OR_NULL(package)) {
+		/* we need only the data */
+		len -= sizeof(*package);
 		data = kmemdup(package->data, len, GFP_KERNEL);
 
 		/* free package regardless of whether kmemdup succeeded */
 		kfree(package);
 
-		if (data) {
-			/* we need only the data size */
-			len -= sizeof(*package);
+		if (data)
 			goto parse;
-		}
 	}
 
 	/* If it's not available, try from the filesystem */
-- 
2.33.0



