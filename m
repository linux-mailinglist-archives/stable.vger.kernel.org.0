Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C5344292
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCVMnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231655AbhCVMlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337CB619C7;
        Mon, 22 Mar 2021 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416761;
        bh=NrpVF5lsezzdjANQSxdVnekep3ctTVAmyvjptOnSXj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRBUndT6kNDclza2nNkbRmQlpKaQdLZeFmddX8j79/LrUt/qDMJu/Pt9pugbLXBIn
         jAOFh/vKBbBOoC7ahbrPf2kE09iYT0GMeCU8dHF69Ze4cz6sR8MIv/aP0xcizBXntK
         bWm5EV4LxAVQWqGyKR+74SepOTksJH8rxCb0Ci9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/157] bpf: Declare __bpf_free_used_maps() unconditionally
Date:   Mon, 22 Mar 2021 13:27:04 +0100
Message-Id: <20210322121935.889181004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index 642ce03f19c4..76322b6452c8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1201,8 +1201,6 @@ struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 int __bpf_prog_charge(struct user_struct *user, u32 pages);
 void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
-void __bpf_free_used_maps(struct bpf_prog_aux *aux,
-			  struct bpf_map **used_maps, u32 len);
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
@@ -1652,6 +1650,9 @@ static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
 	return bpf_prog_get_type_dev(ufd, type, false);
 }
 
+void __bpf_free_used_maps(struct bpf_prog_aux *aux,
+			  struct bpf_map **used_maps, u32 len);
+
 bool bpf_prog_get_ok(struct bpf_prog *, enum bpf_prog_type *, bool);
 
 int bpf_prog_offload_compile(struct bpf_prog *prog);
-- 
2.30.1



