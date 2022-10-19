Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070D6603D1D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiJSI5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiJSI4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FE62651;
        Wed, 19 Oct 2022 01:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A36D66186D;
        Wed, 19 Oct 2022 08:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B323BC433C1;
        Wed, 19 Oct 2022 08:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169488;
        bh=om/giBk3YTiuMx8dz8TMp1iqQLWcdwOEeaBePXe6aw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6J39VaKYngYSEVBq1mS7iAV0sRoEPWCL+zJ/TLt+nGlh4MUflQTYmINTsH2fyUEg
         Wle5dJy5prHCajvUjEJU9p1VGWRIn4MkJlLmiw/b+M5iHwXAQqJxCx9pShd/zycrnR
         7ELAEPG+dGnZXwV3kVZa8MO+GheqByHznt62VL6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 295/862] bpf: Ensure correct locking around vulnerable function find_vpid()
Date:   Wed, 19 Oct 2022 10:26:22 +0200
Message-Id: <20221019083303.050438456@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f798acd43a28..22e7a805c672 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4395,7 +4395,9 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (attr->task_fd_query.flags != 0)
 		return -EINVAL;
 
+	rcu_read_lock();
 	task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+	rcu_read_unlock();
 	if (!task)
 		return -ENOENT;
 
-- 
2.35.1



