Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35D41FE640
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgFRCcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgFRBPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E101C221EB;
        Thu, 18 Jun 2020 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442913;
        bh=xbcdMyZ/zU7XdYMLaTEcniBciHD6hTU30WYvpM9EXOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUasuUFcD3ZJB5r0rJL5sumgGxjBjfF51E/VhLCQWmlooTNbubu6VDkr3ZehHXr+G
         onhoOct+OkdGSwJ3j4UkSwym1s70E6B84resIjSSVj/1MQaujfpt/yiDcULXv9SnPT
         kQ4UPvc+rLBkwB+8MIlBBMBvgojOwgwyeGOzKrfA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 331/388] ext4: don't block for O_DIRECT if IOCB_NOWAIT is set
Date:   Wed, 17 Jun 2020 21:07:08 -0400
Message-Id: <20200618010805.600873-331-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6e014c621e7271649f0d51e54dbe1db4c10486c8 ]

Running with some debug patches to detect illegal blocking triggered the
extend/unaligned condition in ext4. If ext4 needs to extend the file (and
hence go to buffered IO), or if the app is doing unaligned IO, then ext4
asks the iomap code to wait for IO completion. If the caller asked for
no-wait semantics by setting IOCB_NOWAIT, then ext4 should return -EAGAIN
instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

Link: https://lore.kernel.org/r/76152096-2bbb-7682-8fce-4cb498bcd909@kernel.dk
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b8e69f9e3858..2a01e31a032c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -502,6 +502,12 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret <= 0)
 		return ret;
 
+	/* if we're going to block and IOCB_NOWAIT is set, return -EAGAIN */
+	if ((iocb->ki_flags & IOCB_NOWAIT) && (unaligned_io || extend)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	offset = iocb->ki_pos;
 	count = ret;
 
-- 
2.25.1

