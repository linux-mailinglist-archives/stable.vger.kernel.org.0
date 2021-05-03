Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908E6371CDE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhECQ5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234790AbhECQyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 629B561943;
        Mon,  3 May 2021 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060137;
        bh=3OxGgxMHiEXmqEzUZbmOg23yCaocc4iQEm0HrmYm2EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhVQpst4+M18TOEOHrtQ36t4F40QLCww3qhKcpE7EN+0UH0dPHImKpBfXhGozOhY+
         QgZJPnI0r+e8yLeVtHmx520ssv24zL7tevqQvHXAoGx4GgzKeFA41bWARPtvGvvEjB
         Vca9F8qKRpraROPk12YDPh3a/1J63s2UBn6RtVHT4eIAsMLIm20eldOK55V2E/g4lw
         w+8oyPwXlZkn6YGkA+UTIfi26xmdGVISKwXyecw+5eBlWHsRZR5bqbY+J5CoK5Vqdb
         m+9rlyj2gBqP3cjzH29DQH0FKPb8Ly352MM54Ysq00bRZSOowyDbu1120pWOTmW0iL
         rSYBfrod0cZCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/31] media: gspca/sq905.c: fix uninitialized variable
Date:   Mon,  3 May 2021 12:41:41 -0400
Message-Id: <20210503164204.2854178-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index f1da34a10ce8..ec03d18e057f 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -167,7 +167,7 @@ static int
 sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size, int need_lock)
 {
 	int ret;
-	int act_len;
+	int act_len = 0;
 
 	gspca_dev->usb_buf[0] = '\0';
 	if (need_lock)
-- 
2.30.2

