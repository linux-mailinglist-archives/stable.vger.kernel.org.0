Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B124732889A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbhCARnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234721AbhCARfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C3B64FBD;
        Mon,  1 Mar 2021 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617686;
        bh=Vjnctk6S4GYutQmBNqnhu9wrmphTz/IkNeRIwF/Yddo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqQu++GnbJpUqud1htKQ3Vyaz8Y3GC/ehmdIC5KVTm1Z99vFf6xF/U9qKuF/VBJQx
         iTAsC/870gTrs9vhF3NmklkPm2wJfb2Z8biOcAmadud6qrRGoHYqUdGr6barl2Fjf6
         owuVNNCa584lTGcdy9VBA9N9hGCw6yYoeu3STAm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/340] auxdisplay: ht16k33: Fix refresh rate handling
Date:   Mon,  1 Mar 2021 17:11:43 +0100
Message-Id: <20210301161056.144311765@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit e89b0a426721a8ca5971bc8d70aa5ea35c020f90 ]

Drop the call to msecs_to_jiffies(), as "HZ / fbdev->refresh_rate" is
already the number of jiffies to wait.

Fixes: 8992da44c6805d53 ("auxdisplay: ht16k33: Driver for LED controller")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index a2fcde582e2a1..33b887b389061 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -117,8 +117,7 @@ static void ht16k33_fb_queue(struct ht16k33_priv *priv)
 {
 	struct ht16k33_fbdev *fbdev = &priv->fbdev;
 
-	schedule_delayed_work(&fbdev->work,
-			      msecs_to_jiffies(HZ / fbdev->refresh_rate));
+	schedule_delayed_work(&fbdev->work, HZ / fbdev->refresh_rate);
 }
 
 /*
-- 
2.27.0



