Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555DF396226
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhEaOvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231637AbhEaOtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E91E61400;
        Mon, 31 May 2021 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469439;
        bh=4q0YyHM0SbsFNSLazTrvIfuRC/KdV8PwvZYubE5KCAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0q2vFTCwMemZ420iq3TxxpuoedyOGV+Fh3TC2L1WY9u+EMn8o7Lhh2mcMM+kph8cq
         pXxu58mCI2ACyF03AwJpyV94vyyVx2o17NB1c6hoPmgw7+zulftUoqiNYlR9Vko856
         iJ07urG272A20Rn8FMBrNhon+eiU5xR1c2dHkDvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 198/296] Revert "brcmfmac: add a check for the status of usb_register"
Date:   Mon, 31 May 2021 15:14:13 +0200
Message-Id: <20210531130710.536328981@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 30a350947692f794796f563029d29764497f2887 ]

This reverts commit 42daad3343be4a4e1ee03e30a5f5cc731dadfef5.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit here did nothing to actually help if usb_register()
failed, so it gives a "false sense of security" when there is none.  The
correct solution is to correctly unwind from this error.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-69-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 586f4dfc638b..d2a803fc8ac6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1586,10 +1586,6 @@ void brcmf_usb_exit(void)
 
 void brcmf_usb_register(void)
 {
-	int ret;
-
 	brcmf_dbg(USB, "Enter\n");
-	ret = usb_register(&brcmf_usbdrvr);
-	if (ret)
-		brcmf_err("usb_register failed %d\n", ret);
+	usb_register(&brcmf_usbdrvr);
 }
-- 
2.30.2



