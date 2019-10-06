Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CCCD4D2
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfJFR3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbfJFR3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99792080F;
        Sun,  6 Oct 2019 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382970;
        bh=PPtC1byf+ycl0gIBvOoGFB9Pn3P+DpibUDguInGQ/6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqFk6nnOw2nfqjSPWWY+sgd4HFpQgWEVtxbMX49NAK8Gj7HQ9ZWHiTcavuOy2Z4lO
         /qblhaPWzPSvMmTsTyqNqCkVxRa/hnPnXVp+mMcWzBDOm0qdMk5O44PN7qT16EsMT1
         cGquFOaBm+HDVO0+SDGZMVGEUXEqmT2lBCUWtQxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marko Kohtala <marko.kohtala@okoko.fi>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/106] video: ssd1307fb: Start page range at page_offset
Date:   Sun,  6 Oct 2019 19:20:11 +0200
Message-Id: <20191006171127.025346157@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marko Kohtala <marko.kohtala@okoko.fi>

[ Upstream commit dd9782834dd9dde3624ff1acea8859f3d3e792d4 ]

The page_offset was only applied to the end of the page range. This caused
the display updates to cause a scrolling effect on the display because the
amount of data written to the display did not match the range display
expected.

Fixes: 301bc0675b67 ("video: ssd1307fb: Make use of horizontal addressing mode")
Signed-off-by: Marko Kohtala <marko.kohtala@okoko.fi>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618074111.9309-4-marko.kohtala@okoko.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 6439231f2db22..da565f39c9b06 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -433,7 +433,7 @@ static int ssd1307fb_init(struct ssd1307fb_par *par)
 	if (ret < 0)
 		return ret;
 
-	ret = ssd1307fb_write_cmd(par->client, 0x0);
+	ret = ssd1307fb_write_cmd(par->client, par->page_offset);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1



