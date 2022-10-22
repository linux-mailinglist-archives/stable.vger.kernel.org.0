Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615006086DF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiJVHzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiJVHwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068042CA7D1;
        Sat, 22 Oct 2022 00:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC0460B1B;
        Sat, 22 Oct 2022 07:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9334DC433D6;
        Sat, 22 Oct 2022 07:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424726;
        bh=HiG51sHsMxzHVedBNQE+5UlO3SgRy+hGjnxhkYctKZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAkJz2rF0MLx3D+TcCVHce3fpLksAVq04ESX+07XTU8zGonEa3zblzQ7RLaYlo8S8
         QiiHRycYFPadX5KPDAS1DKza27bo4SWRSb0ErLH7WttiYin+ZnV59GdJmajtUgOJS8
         hrEl/5unbHY1OffR7tF27lKgcuOSEzlLOoOM+/AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 253/717] bpf: Ensure correct locking around vulnerable function find_vpid()
Date:   Sat, 22 Oct 2022 09:22:12 +0200
Message-Id: <20221022072459.614445182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 7a3444988c84..494ba88054e8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4361,7 +4361,9 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (attr->task_fd_query.flags != 0)
 		return -EINVAL;
 
+	rcu_read_lock();
 	task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+	rcu_read_unlock();
 	if (!task)
 		return -ENOENT;
 
-- 
2.35.1



