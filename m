Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6328D60ABC6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiJXN4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiJXNyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:54:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A4BBE2F7;
        Mon, 24 Oct 2022 05:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 119376134B;
        Mon, 24 Oct 2022 12:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213E2C433D6;
        Mon, 24 Oct 2022 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615248;
        bh=TlaoLn9ohK2u5dmXZHjSpX9T2q+00XCK22CH9SiBhg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTxmvWpub+TgMDlZ8S75WnKqOA/mtI7I7UFFVMzXL60cVq3XlrgCxhVMku6pXY0e8
         AIdiMr9uXpdqfH3mM+xvSr8y+13zkRat3onNo8UNPlBUwwlkJyQXCqco627cMf+46K
         KCDa8B7j3Iti7XvnA8fiP4yuMOMvon5CeXngdcIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/530] bpf: Ensure correct locking around vulnerable function find_vpid()
Date:   Mon, 24 Oct 2022 13:28:43 +0200
Message-Id: <20221024113053.131747078@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee@kernel.org>

[ Upstream commit 83c10cc362d91c0d8d25e60779ee52fdbbf3894d ]

The documentation for find_vpid() clearly states:

  "Must be called with the tasklist_lock or rcu_read_lock() held."

Presently we do neither for find_vpid() instance in bpf_task_fd_query().
Add proper rcu_read_lock/unlock() to fix the issue.

Fixes: 41bdc4b40ed6f ("bpf: introduce bpf subcommand BPF_TASK_FD_QUERY")
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220912133855.1218900-1-lee@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 99ce46f51889..aea9852f1c22 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4100,7 +4100,9 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (attr->task_fd_query.flags != 0)
 		return -EINVAL;
 
+	rcu_read_lock();
 	task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+	rcu_read_unlock();
 	if (!task)
 		return -ENOENT;
 
-- 
2.35.1



