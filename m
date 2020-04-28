Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DD1BCB0F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgD1SeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgD1SeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587F620B80;
        Tue, 28 Apr 2020 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098861;
        bh=no3knKj15K/kqw5BYs/rcA1+Ow+Jsr8lPJT0094hSSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVwnma7udfIIoMsYuqFX7HoOkEExMeH/EZnGUEQvg3Vo/c0PR+C4qanritqoy0JTx
         /5kSCK4tCvQHxjgSFwg2GFRZIrY6Ah2IEsUKCzf+rhewcslU5I4wVygY3eK8S18H+d
         T4UKiXa+ThGL2n4RCrB1crr8yAaX+wrR36w/ouDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ingo Molnar <mingo@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        NeilBrown <neilb@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Waiman Long <longman@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/168] kernel/gcov/fs.c: gcov_seq_next() should increase position index
Date:   Tue, 28 Apr 2020 20:23:18 +0200
Message-Id: <20200428182234.767115767@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit f4d74ef6220c1eda0875da30457bef5c7111ab06 ]

If seq_file .next function does not change position index, read after
some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <longman@redhat.com>
Link: http://lkml.kernel.org/r/f65c6ee7-bd00-f910-2f8a-37cc67e4ff88@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index e5eb5ea7ea598..cc4ee482d3fba 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -108,9 +108,9 @@ static void *gcov_seq_next(struct seq_file *seq, void *data, loff_t *pos)
 {
 	struct gcov_iterator *iter = data;
 
+	(*pos)++;
 	if (gcov_iter_next(iter))
 		return NULL;
-	(*pos)++;
 
 	return iter;
 }
-- 
2.20.1



