Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8524B1E2BFA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391147AbgEZTKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404023AbgEZTKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5698620776;
        Tue, 26 May 2020 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520246;
        bh=vhhw2Jdi95VXXXtnhoiGlwXjDgEAcBNldmfG9VokCCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpAwZpta+kn3fIfQDhkFyhKnORoRLRIk9XnU/mm/B9cdl/svkRuGjo4/MTnbgC3Sn
         /wrsZ5ZNB/Bv2T/v/Mb0b9usDI9nodj6mkGE+Un9gV1fLNNghZFYS+fWh0NccMRxnY
         ppgwmPgtz8WMIYLOXkElb+IMFJ/OPdOpscHuzFLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/111] bpf: Avoid setting bpf insns pages read-only when prog is jited
Date:   Tue, 26 May 2020 20:53:36 +0200
Message-Id: <20200526183940.262459918@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e1608f3fa857b600045b6df7f7dadc70eeaa4496 ]

For the case where the interpreter is compiled out or when the prog is jited
it is completely unnecessary to set the BPF insn pages as read-only. In fact,
on frequent churn of BPF programs, it could lead to performance degradation of
the system over time since it would break the direct map down to 4k pages when
calling set_memory_ro() for the insn buffer on x86-64 / arm64 and there is no
reverse operation. Thus, avoid breaking up large pages for data maps, and only
limit this to the module range used by the JIT where it is necessary to set
the image read-only and executable.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191129222911.3710-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 0367a75f873b..3bbc72dbc69e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -770,8 +770,12 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
-	set_vm_flush_reset_perms(fp);
-	set_memory_ro((unsigned long)fp, fp->pages);
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+	if (!fp->jited) {
+		set_vm_flush_reset_perms(fp);
+		set_memory_ro((unsigned long)fp, fp->pages);
+	}
+#endif
 }
 
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
-- 
2.25.1



