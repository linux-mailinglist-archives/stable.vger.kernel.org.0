Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A28F799
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfD3MAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbfD3Lpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A798221670;
        Tue, 30 Apr 2019 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624740;
        bh=hplInzEK2u4jRyTMgl9aER7j6CPUgDmKh8VJJamwZGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq1b4P+/XrHUf59OHpi+ZrCmhrclF5GptGO1J0GPhm5XSod++n5aRshb0agdfW5qH
         lNI18IAydzACN5dcsh03F8fHHansX8fyMBxAjZys5ZDddXqXn3bx2p6t2bRhtSAw5R
         b9Oqtv8EQGqMZi+JySCzmpaXmA/Wp7unwyEgLw/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 055/100] workqueue: Try to catch flush_work() without INIT_WORK().
Date:   Tue, 30 Apr 2019 13:38:24 +0200
Message-Id: <20190430113611.541863454@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 4d43d395fed124631ca02356c711facb90185175 upstream.

syzbot found a flush_work() caller who forgot to call INIT_WORK()
because that work_struct was allocated by kzalloc() [1]. But the message

  INFO: trying to register non-static key.
  the code is fine but needs lockdep annotation.
  turning off the locking correctness validator.

by lock_map_acquire() is failing to tell that INIT_WORK() is missing.

Since flush_work() without INIT_WORK() is a bug, and INIT_WORK() should
set ->func field to non-zero, let's warn if ->func field is zero.

[1] https://syzkaller.appspot.com/bug?id=a5954455fcfa51c29ca2ab55b203076337e1c770

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2908,6 +2908,9 @@ static bool __flush_work(struct work_str
 	if (WARN_ON(!wq_online))
 		return false;
 
+	if (WARN_ON(!work->func))
+		return false;
+
 	if (!from_cancel) {
 		lock_map_acquire(&work->lockdep_map);
 		lock_map_release(&work->lockdep_map);


