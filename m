Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8760371D43
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhECQ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbhECQ4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FE1E61421;
        Mon,  3 May 2021 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060216;
        bh=lOswd8yokzUhDq6iGB8LlKGAW5t938NIF0opdt12Too=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkpx8thWPcGLEeaOBbnhQHY9xRxtcIpxoLpZbPPdoi7EwlTYlF9gmrHQQ+E2OVEc3
         j1Q2xwYmKMMYQQ3b1riEKOJy2a2wncsDawCMmmyC6Ql9JZwFZl1cw5uqgag4RS/2Af
         Wi4ivV/limApvpJt7vT8rsfXCZlMppVd1bhyAanZ6fQ+QWA5r1ABcd/yo/mzjBjhJ6
         dHrdj9mPefjX/R1/QDtahnC+aQBAq+F8yPirp7cdtqgbSrZ+rgqs2hVHTcCDbOVqXT
         bWb6wkgxcyE6QwWrjTlYq5sqb9jNueN0gigGPapqcBeVhqBpagu501s4GcE7mGtAYj
         jtzNnFnjTVtsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+a4e309017a5f3a24c7b3@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/16] media: gspca/sq905.c: fix uninitialized variable
Date:   Mon,  3 May 2021 12:43:17 -0400
Message-Id: <20210503164329.2854739-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
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

