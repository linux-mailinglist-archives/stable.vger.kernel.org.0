Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975F63033B7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbhAZFDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbhAYSwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C391820758;
        Mon, 25 Jan 2021 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600721;
        bh=ZyWuKXthMxWtsaLohxHWLnb8UvzOoVhzaSyUSQZ74cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaTjLGo2DOuplA+qh/15ZybghsFR+ShcdeoxFesi1AfyKlGMrDL07TLfQfYt2tyse
         52iwByZvMWH+qZU4nb7bxSjomJ0a0GMsuW2dWfBvzdQSf3aQEBN+7n4iLDNY0MQVx0
         4u6lAY7lKkfZzjR2WYcXAgZWJu6ZHpDOvAmKeLTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/199] printk: ringbuffer: fix line counting
Date:   Mon, 25 Jan 2021 19:38:37 +0100
Message-Id: <20210125183220.288395830@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 668af87f995b6d6d09595c088ad1fb5dd9ff25d2 ]

Counting text lines in a record simply involves counting the number
of newline characters (+1). However, it is searching the full data
block for newline characters, even though the text data can be (and
often is) a subset of that area. Since the extra area in the data
block was never initialized, the result is that extra newlines may
be seen and counted.

Restrict newline searching to the text data length.

Fixes: b6cf8b3f3312 ("printk: add lockless ringbuffer")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210113144234.6545-1-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk_ringbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index 74e25a1704f2b..617dd63589650 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -1720,7 +1720,7 @@ static bool copy_data(struct prb_data_ring *data_ring,
 
 	/* Caller interested in the line count? */
 	if (line_count)
-		*line_count = count_lines(data, data_size);
+		*line_count = count_lines(data, len);
 
 	/* Caller interested in the data content? */
 	if (!buf || !buf_size)
-- 
2.27.0



