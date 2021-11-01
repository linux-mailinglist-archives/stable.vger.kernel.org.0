Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80104418E5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhKAJwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhKAJut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C734060F58;
        Mon,  1 Nov 2021 09:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759134;
        bh=0+ocs282GQVwxKxy0MEmmcQiQYYxeOd2a0AHQoqPTkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txuMTgLMlTI4HFx22ufcukuHN9tHB8aO+Gu+mL6NF8PYEwBokvcZRSfKLhk6s57De
         QrxCAl/aVnt31u3ckBlMtKibSXolSNsf3XG4R6T2VDMNT/w6HVrjBrdUCUyFnD7G/m
         R0z37QR/aXoX09xtQk/fJtqttrFa15SyNdL3hQ7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 108/125] bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE outside of CONFIG_NET
Date:   Mon,  1 Nov 2021 10:18:01 +0100
Message-Id: <20211101082553.560890936@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 99d0a3831e3500d945162cdb2310e3a5fce90b60 ]

bpf_types.h has BPF_MAP_TYPE_INODE_STORAGE and BPF_MAP_TYPE_TASK_STORAGE
declared inside #ifdef CONFIG_NET although they are built regardless of
CONFIG_NET. So, when CONFIG_BPF_SYSCALL && !CONFIG_NET, they are built
without the declarations leading to spurious build failures and not
registered to bpf_map_types making them unavailable.

Fix it by moving the BPF_MAP_TYPE for the two map types outside of
CONFIG_NET.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: a10787e6d58c ("bpf: Enable task local storage for tracing programs")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/YXG1cuuSJDqHQfRY@slm.duckdns.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_types.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index ae3ac3a2018c..2eb9c53468e7 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -101,14 +101,14 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK_TRACE, stack_trace_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
-#ifdef CONFIG_NET
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 #ifdef CONFIG_BPF_LSM
 BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
+#ifdef CONFIG_NET
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
 BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
-- 
2.33.0



