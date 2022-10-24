Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D960AA27
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiJXNbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbiJXN3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE49E12A9A;
        Mon, 24 Oct 2022 05:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34C5B81212;
        Mon, 24 Oct 2022 12:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0D6C4314E;
        Mon, 24 Oct 2022 12:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613271;
        bh=eu3dHn2Lu/ALN7PdPni6DW2q/Erc6p8YdVQGodhk4OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqGN/J9aNfxZggqej0WeCfHpFcT0YIFJ6Tg4/Ck09XW0zlt57UVyJWu1wmTHubJt9
         GDRECsKBVPKeLr0/JDgCUu1yP3lL1h/WHoDPTdSyS7yjYXMCEm2ynaGZsvGUvY3GIf
         bJTvK+t4IfyVP1fc+pMOvd+tOxW9xafjVWMo54NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/255] bpf: Ensure correct locking around vulnerable function find_vpid()
Date:   Mon, 24 Oct 2022 13:29:44 +0200
Message-Id: <20221024113004.972494500@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index 9ebdcdaa5f16..de788761b708 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2787,7 +2787,9 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (attr->task_fd_query.flags != 0)
 		return -EINVAL;
 
+	rcu_read_lock();
 	task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+	rcu_read_unlock();
 	if (!task)
 		return -ENOENT;
 
-- 
2.35.1



