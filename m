Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3023289B9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhCASDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238292AbhCAR4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36F1964F58;
        Mon,  1 Mar 2021 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620411;
        bh=UHO1R0MIiVfqXFJir/glVUeoflpMlrooTURLOHO8NiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SctDvuXmTWihCd6vEbgwGh6YTLAqVMZMDXiHPad0pWMnUyYmWaapzqwaE4J5iXYzU
         1XaVDaNcisaiHi+VHNIkGT3WnzdsPglbzLIQg6Vwg+KUqqQ4O4fcopykZUfB/bcRQ+
         3thd5c9rdDco3Dh1r+Kd5qQ77y9cqs1/ycc+2UsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 144/775] bpf: Declare __bpf_free_used_maps() unconditionally
Date:   Mon,  1 Mar 2021 17:05:12 +0100
Message-Id: <20210301161208.765625118@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 936f8946bdb48239f4292812d4d2e26c6d328c95 ]

__bpf_free_used_maps() is always defined in kernel/bpf/core.c, while
include/linux/bpf.h is guarding it behind CONFIG_BPF_SYSCALL. Move it out of
that guard region and fix compiler warning.

Fixes: a2ea07465c8d ("bpf: Fix missing prog untrack in release_maps")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210112075520.4103414-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ef9309604b3e5..6e585dbc10df3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1206,8 +1206,6 @@ void bpf_prog_sub(struct bpf_prog *prog, int i);
 void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
-void __bpf_free_used_maps(struct bpf_prog_aux *aux,
-			  struct bpf_map **used_maps, u32 len);
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
@@ -1676,6 +1674,9 @@ static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
 	return bpf_prog_get_type_dev(ufd, type, false);
 }
 
+void __bpf_free_used_maps(struct bpf_prog_aux *aux,
+			  struct bpf_map **used_maps, u32 len);
+
 bool bpf_prog_get_ok(struct bpf_prog *, enum bpf_prog_type *, bool);
 
 int bpf_prog_offload_compile(struct bpf_prog *prog);
-- 
2.27.0



