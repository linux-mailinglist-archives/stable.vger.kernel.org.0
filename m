Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCF8469E07
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388533AbhLFPeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387470AbhLFPbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70484B8101C;
        Mon,  6 Dec 2021 15:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5947C34900;
        Mon,  6 Dec 2021 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804473;
        bh=VIzf9OTZg8VPybStcPS96y153x5xZpKSYgAif9kO37Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgGZWbWBl2J4LuP2rWSBm7FePF+iICHpoIGpRyMRMiPXC+e+02tVrLKDPZJ6+TM1t
         XAuhYE2lX96xqTRitoQuVpUDpCklTUS8bLsx2eTRd87qrqzriBKa0R23MTRpNLKV/w
         UC8zFfwVl3J9wzBAHZDo0mW32ZXnodotkrrp+cvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/207] iwlwifi: Fix memory leaks in error handling path
Date:   Mon,  6 Dec 2021 15:56:53 +0100
Message-Id: <20211206145615.778268351@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a571bc28326d9f3e13f5f2d9cda2883e0631b0ce ]

Should an error occur (invalid TLV len or memory allocation failure), the
memory already allocated in 'reduce_power_data' should be freed before
returning, otherwise it is leaking.

Fixes: 9dad325f9d57 ("iwlwifi: support loading the reduced power table from UEFI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1504cd7d842d13ddb8244e18004523128d5c9523.1636615284.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index c875bf35533ce..009dd4be597b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -86,6 +86,7 @@ static void *iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 		if (len < tlv_len) {
 			IWL_ERR(trans, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
+			kfree(reduce_power_data);
 			reduce_power_data = ERR_PTR(-EINVAL);
 			goto out;
 		}
@@ -105,6 +106,7 @@ static void *iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 				IWL_DEBUG_FW(trans,
 					     "Couldn't allocate (more) reduce_power_data\n");
 
+				kfree(reduce_power_data);
 				reduce_power_data = ERR_PTR(-ENOMEM);
 				goto out;
 			}
@@ -134,6 +136,10 @@ static void *iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 done:
 	if (!size) {
 		IWL_DEBUG_FW(trans, "Empty REDUCE_POWER, skipping.\n");
+		/* Better safe than sorry, but 'reduce_power_data' should
+		 * always be NULL if !size.
+		 */
+		kfree(reduce_power_data);
 		reduce_power_data = ERR_PTR(-ENOENT);
 		goto out;
 	}
-- 
2.33.0



