Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F07412600
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353786AbhITSwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385436AbhITSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3C261371;
        Mon, 20 Sep 2021 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159283;
        bh=m3/X0nqi7M3hpujLanY9ZYmazN/XQXQIXcCIK34Dzao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vau+EKmzs73bin6FSlJjlvKWhk2gFotRivGD5kOANqeAQ4obFOq/CfU1lBTn4zMJk
         8+lHHsdTBa4OiQPjTrd+Y/kYiUcPtB0rKkWkhUqqczzqscrJ2HwqKtnX1McPHPoE3x
         JDJcLW9JlV3nTVrFBu0xTkUvrM5dQBvtJ1LQG8ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luca@coelho.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 159/168] iwlwifi: pnvm: Fix a memory leak in iwl_pnvm_get_from_fs()
Date:   Mon, 20 Sep 2021 18:44:57 +0200
Message-Id: <20210920163926.894504439@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 45010c080e6e7434fcae73212b0087a03590049f ]

A firmware is requested but never released in this function. This leads to
a memory leak in the normal execution path.

Add the missing 'release_firmware()' call.
Also introduce a temp variable (new_len) in order to keep the value of
'pnvm->size' after the firmware has been released.

Fixes: cdda18fbbefa ("iwlwifi: pnvm: move file loading code to a separate function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Luca Coelho <luca@coelho.fi>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1b5d80f54c1dbf85710fd285243932943b498fe7.1630614969.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 830257e94126..513f9e538729 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -231,6 +231,7 @@ static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 {
 	const struct firmware *pnvm;
 	char pnvm_name[MAX_PNVM_NAME];
+	size_t new_len;
 	int ret;
 
 	iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
@@ -242,11 +243,14 @@ static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 		return ret;
 	}
 
+	new_len = pnvm->size;
 	*data = kmemdup(pnvm->data, pnvm->size, GFP_KERNEL);
+	release_firmware(pnvm);
+
 	if (!*data)
 		return -ENOMEM;
 
-	*len = pnvm->size;
+	*len = new_len;
 
 	return 0;
 }
-- 
2.30.2



