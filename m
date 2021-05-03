Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF825371BA5
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhECQrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhECQpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6C761613;
        Mon,  3 May 2021 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059947;
        bh=5LnsDbENCZlQF4nCWMHw2rIS0V68TkYnwy3mGlCDfCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPhwkkcZ/aKUJCigBZrYS/HnO7KfcFNTrRkMRiJRqtHEn0ONd8G9fg2IbyMZn/+kK
         Jj1qKdt0PhHc0k8M7ZB7yJHiiBPDY7EQx61EvLrhatOmzra1ryaCa+9xRO49s7gnnE
         45R/3yZia7/4Q+GfYFLNCf+M/qjZrkoTdCiEEtKM9b7MRfBeyv9v0AS1YbLKjlJiRX
         U6abljZ37GK+OrZrtg7Bq86fxiVf3u0SIvXBRi3cJzCOhVJZ/wxR9fd3h/f+Ygsx8r
         TLr+R9H4/Bp+0k8UUtDXy+cV1cny3Vzyf+VDwNYVqQWGv6qYF8BQ9yxe6ZQaPXMF/3
         pgjA+syP1HTmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 025/100] media: gspca/sq905.c: fix uninitialized variable
Date:   Mon,  3 May 2021 12:37:14 -0400
Message-Id: <20210503163829.2852775-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit eaaea4681984c79d2b2b160387b297477f0c1aab ]

act_len can be uninitialized if usb_bulk_msg() returns an error.
Set it to 0 to avoid a KMSAN error.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/sq905.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index 97799cfb832e..949111070971 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -158,7 +158,7 @@ static int
 sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size, int need_lock)
 {
 	int ret;
-	int act_len;
+	int act_len = 0;
 
 	gspca_dev->usb_buf[0] = '\0';
 	if (need_lock)
-- 
2.30.2

