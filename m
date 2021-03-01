Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41593289FA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhCASJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238960AbhCASCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9945E651D5;
        Mon,  1 Mar 2021 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619061;
        bh=U/IgthPYfK2vQ3LO/QcjtFLaKIoHRiltgLmmsYS5/Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlcapZTe3D0KFswzhKUaZWSeteljt6sLQRV0UNOFU2CL3WBOEATh/x9/hn13Hsa4F
         0UF59v+1Jp6A416Io2YO8sPJSFcqnIXn3cxU1Hp7cxpKu0yJEJ961HXpZIPtcKbswH
         1ZhawHBpqC1AuAVGVA0/5H0BrSz+MEzjJ1DLhR1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/663] auxdisplay: ht16k33: Fix refresh rate handling
Date:   Mon,  1 Mar 2021 17:09:25 +0100
Message-Id: <20210301161157.535023324@linuxfoundation.org>
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
index d951d54b26f52..d8602843e8a53 100644
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



