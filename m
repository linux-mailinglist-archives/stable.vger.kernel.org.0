Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A3638A846
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbhETKsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238075AbhETKqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 393156162C;
        Thu, 20 May 2021 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504681;
        bh=lOswd8yokzUhDq6iGB8LlKGAW5t938NIF0opdt12Too=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ0HWaGw0QvK8+PNx0tsqLuAasjxutYN0TxyyM0oWsx8WlP4jCy9XCP3U+QGdOGPn
         l4DYNB+XFXv/ZlMt8i5Kwed2azo/DCoGJjOBL4uN803k9F0KaAonNiuSY/Ze4RObvq
         IVemFUwvXF3N6dSD2BNUR9OKBokPEXH68XcX74GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 031/240] media: gspca/sq905.c: fix uninitialized variable
Date:   Thu, 20 May 2021 11:20:23 +0200
Message-Id: <20210520092109.700568368@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index a7ae0ec9fa91..03322d2b2e82 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -172,7 +172,7 @@ static int
 sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size, int need_lock)
 {
 	int ret;
-	int act_len;
+	int act_len = 0;
 
 	gspca_dev->usb_buf[0] = '\0';
 	if (need_lock)
-- 
2.30.2



