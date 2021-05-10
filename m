Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2BC378827
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbhEJLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234224AbhEJLJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 389156191C;
        Mon, 10 May 2021 11:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644680;
        bh=5LnsDbENCZlQF4nCWMHw2rIS0V68TkYnwy3mGlCDfCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYktaXjfAlu+Vf7Hol801vInbVBqwEV8EH/fqLCP3hYDBTZMh1fmuDBdGEJsJrYPE
         vAVixlI00M01srbitqmNbtOS06pPW/XkRN/NDRujyPxn4GYjNW7uu1+Qb64u/f8O5J
         xqtfrxUpsekvs7vUg12NA53cQpEBuPvt2gLsu7tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 179/384] media: gspca/sq905.c: fix uninitialized variable
Date:   Mon, 10 May 2021 12:19:28 +0200
Message-Id: <20210510102020.791047814@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



