Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E06328701
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbhCARS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237358AbhCARLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:11:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF7364ED9;
        Mon,  1 Mar 2021 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616979;
        bh=UUua6UXLZUyGz5W22RL/hvUmbMLew6PK3JO1vXiNIkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjukDUd8b5ecB3bDfiJGiBEE1ZYijHQ8i7I5ZasKEPleP0tuTinKleNWRaSb4a6CB
         QLOL2XQiXQqZPT0P+74MjAMPivGvj9M+DfillEyu65sZVKvNHwDRqTwfwVxsLyM58w
         PcBu//usKApVlOOp0ARTmMUNf5ITWdynb94g3hzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/247] auxdisplay: ht16k33: Fix refresh rate handling
Date:   Mon,  1 Mar 2021 17:12:30 +0100
Message-Id: <20210301161038.038916323@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 21393ec3b9a4a..194370ae37dd0 100644
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



