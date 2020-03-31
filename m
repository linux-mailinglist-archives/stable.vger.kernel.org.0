Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA21991DA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbgCaJIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730995AbgCaJIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F60520787;
        Tue, 31 Mar 2020 09:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645716;
        bh=yOKg1tKJy2bt2wOT/yU5kFgS1IBYg+vcjwOpadC+8l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwYu018HOPuu5HkPele6HQhjr2r5l08mKxApJogTi8XQb596GunfyQPZeIhHpdywF
         Cr/tLuT2olA6IoCstLfjRT+NbZENh76lkwFbl6hqGc3NJ8b1PoMx4Wlgmh+JV0ODPi
         wTg5NbNLQsxopOwR+WnWTDEEji0Fkw7Wm/l2VY6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.5 141/170] bpf: Initialize storage pointers to NULL to prevent freeing garbage pointer
Date:   Tue, 31 Mar 2020 10:59:15 +0200
Message-Id: <20200331085438.385948489@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 62039c30c19dcab96621e074aeeb90da7100def7 upstream.

Local storage array isn't initialized, so if cgroup storage allocation fails
for BPF_CGROUP_STORAGE_SHARED, error handling code will attempt to free
uninitialized pointer for BPF_CGROUP_STORAGE_PERCPU storage type. Avoid this
by always initializing storage pointers to NULLs.

Fixes: 8bad74f9840f ("bpf: extend cgroup bpf core to allow multiple cgroup storage types")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200309222756.1018737-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -303,8 +303,8 @@ int __cgroup_bpf_attach(struct cgroup *c
 {
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	struct bpf_prog *old_prog = NULL;
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
-		*old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_list *pl;
 	bool pl_was_allocated;


