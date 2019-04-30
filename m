Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC848F6D9
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfD3Lwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730475AbfD3Lvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:51:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5620E2054F;
        Tue, 30 Apr 2019 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625092;
        bh=wvkeDZFULudm6VnfULGjkMBtkwZGugK3mgVamZUMmBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVXjJ6ZJfj7ox2eoAUFRJGZapK6STuft4B1Dh2YpNVl9UrdEer3fiMMk/+6ejhKs7
         qewEA9P0ELNfFu6qI7YFP3lWn2UadTAAfn5R6dlhOJrxdAItgbDxJvPGMUDcJY64uV
         t+2FRccA42ALdMsoX3hO87OzmYtx0iY2lY2wagHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.0 52/89] workqueue: Try to catch flush_work() without INIT_WORK().
Date:   Tue, 30 Apr 2019 13:38:43 +0200
Message-Id: <20190430113612.128748223@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
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
@@ -2931,6 +2931,9 @@ static bool __flush_work(struct work_str
 	if (WARN_ON(!wq_online))
 		return false;
 
+	if (WARN_ON(!work->func))
+		return false;
+
 	if (!from_cancel) {
 		lock_map_acquire(&work->lockdep_map);
 		lock_map_release(&work->lockdep_map);


