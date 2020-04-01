Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C598E19B446
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgDAQVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbgDAQVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3ABB20857;
        Wed,  1 Apr 2020 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758101;
        bh=wBrE6gDlyZuwjMqIa3DxaNdN4BzjNwC4Wqm8ffpoJr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khK8hUJRfKcRep1gnE3wMDhqRa0f8pg8i06/eKgRceMVox3vUISSJGX81TSzmSuOU
         lM03EyKc1NizEWw0YyQx6Uat0cgiQfUdjpLu3O7HsJP29Tb5qYpZ/qcaALviRcI9eJ
         hYtABCm3ekue3twv1SklZINS2jtrrzCKd1LiX7uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.4 12/27] bpf: Explicitly memset some bpf info structures declared on the stack
Date:   Wed,  1 Apr 2020 18:17:40 +0200
Message-Id: <20200401161425.422896494@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5c6f25887963f15492b604dd25cb149c501bbabf upstream.

Trying to initialize a structure with "= {};" will not always clean out
all padding locations in a structure. So be explicit and call memset to
initialize everything for a number of bpf information structures that
are then copied from userspace, sometimes from smaller memory locations
than the size of the structure.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200320162258.GA794295@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/btf.c     |    3 ++-
 kernel/bpf/syscall.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3460,7 +3460,7 @@ int btf_get_info_by_fd(const struct btf
 		       union bpf_attr __user *uattr)
 {
 	struct bpf_btf_info __user *uinfo;
-	struct bpf_btf_info info = {};
+	struct bpf_btf_info info;
 	u32 info_copy, btf_copy;
 	void __user *ubtf;
 	u32 uinfo_len;
@@ -3469,6 +3469,7 @@ int btf_get_info_by_fd(const struct btf
 	uinfo_len = attr->info.info_len;
 
 	info_copy = min_t(u32, uinfo_len, sizeof(info));
+	memset(&info, 0, sizeof(info));
 	if (copy_from_user(&info, uinfo, info_copy))
 		return -EFAULT;
 
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2325,7 +2325,7 @@ static int bpf_prog_get_info_by_fd(struc
 				   union bpf_attr __user *uattr)
 {
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_prog_info info = {};
+	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
 	struct bpf_prog_stats stats;
 	char __user *uinsns;
@@ -2337,6 +2337,7 @@ static int bpf_prog_get_info_by_fd(struc
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	if (copy_from_user(&info, uinfo, info_len))
 		return -EFAULT;
 
@@ -2600,7 +2601,7 @@ static int bpf_map_get_info_by_fd(struct
 				  union bpf_attr __user *uattr)
 {
 	struct bpf_map_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_map_info info = {};
+	struct bpf_map_info info;
 	u32 info_len = attr->info.info_len;
 	int err;
 
@@ -2609,6 +2610,7 @@ static int bpf_map_get_info_by_fd(struct
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	info.type = map->map_type;
 	info.id = map->id;
 	info.key_size = map->key_size;


