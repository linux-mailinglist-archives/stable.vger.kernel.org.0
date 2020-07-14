Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8185621FB82
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbgGNTCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730271AbgGNS6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56529207F5;
        Tue, 14 Jul 2020 18:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753131;
        bh=xvpfu3OKYXrf/Hf0b94tFHvzshmHtSyVnvWgsY1rVjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEr+JsHo5FWDsKl+J0LSMSsdISCkCxKOMNZdnFa1RkgTeFVE8mPnIvc1YIWwOrw+E
         JfUkwmB/BY96h775Z8FoA8Pb1b7I9KaQmfQKnLjQIOFGPJYTOj83eXXC85cIir16zZ
         EWTsZZqrhTSIaGCOFFi4iwI1zTt+kqq7VlGvehwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.7 132/166] bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()
Date:   Tue, 14 Jul 2020 20:44:57 +0200
Message-Id: <20200714184122.156831179@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 63960260457a02af2a6cb35d75e6bdb17299c882 upstream.

When evaluating access control over kallsyms visibility, credentials at
open() time need to be used, not the "current" creds (though in BPF's
case, this has likely always been the same). Plumb access to associated
file->f_cred down through bpf_dump_raw_ok() and its callers now that
kallsysm_show_value() has been refactored to take struct cred.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 7105e828c087 ("bpf: allow for correlation of maps and helpers in dump")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/filter.h     |    4 ++--
 kernel/bpf/syscall.c       |   32 ++++++++++++++++++--------------
 net/core/sysctl_net_core.c |    2 +-
 3 files changed, 21 insertions(+), 17 deletions(-)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -888,12 +888,12 @@ void bpf_jit_compile(struct bpf_prog *pr
 bool bpf_jit_needs_zext(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
-static inline bool bpf_dump_raw_ok(void)
+static inline bool bpf_dump_raw_ok(const struct cred *cred)
 {
 	/* Reconstruction of call-sites is dependent on kallsyms,
 	 * thus make dump the same restriction.
 	 */
-	return kallsyms_show_value(current_cred());
+	return kallsyms_show_value(cred);
 }
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2918,7 +2918,8 @@ static const struct bpf_map *bpf_map_fro
 	return NULL;
 }
 
-static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
+static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog,
+					      const struct cred *f_cred)
 {
 	const struct bpf_map *map;
 	struct bpf_insn *insns;
@@ -2944,7 +2945,7 @@ static struct bpf_insn *bpf_insn_prepare
 		    code == (BPF_JMP | BPF_CALL_ARGS)) {
 			if (code == (BPF_JMP | BPF_CALL_ARGS))
 				insns[i].code = BPF_JMP | BPF_CALL;
-			if (!bpf_dump_raw_ok())
+			if (!bpf_dump_raw_ok(f_cred))
 				insns[i].imm = 0;
 			continue;
 		}
@@ -3000,7 +3001,8 @@ static int set_info_rec_size(struct bpf_
 	return 0;
 }
 
-static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
+static int bpf_prog_get_info_by_fd(struct file *file,
+				   struct bpf_prog *prog,
 				   const union bpf_attr *attr,
 				   union bpf_attr __user *uattr)
 {
@@ -3069,11 +3071,11 @@ static int bpf_prog_get_info_by_fd(struc
 		struct bpf_insn *insns_sanitized;
 		bool fault;
 
-		if (prog->blinded && !bpf_dump_raw_ok()) {
+		if (prog->blinded && !bpf_dump_raw_ok(file->f_cred)) {
 			info.xlated_prog_insns = 0;
 			goto done;
 		}
-		insns_sanitized = bpf_insn_prepare_dump(prog);
+		insns_sanitized = bpf_insn_prepare_dump(prog, file->f_cred);
 		if (!insns_sanitized)
 			return -ENOMEM;
 		uinsns = u64_to_user_ptr(info.xlated_prog_insns);
@@ -3107,7 +3109,7 @@ static int bpf_prog_get_info_by_fd(struc
 	}
 
 	if (info.jited_prog_len && ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			uinsns = u64_to_user_ptr(info.jited_prog_insns);
 			ulen = min_t(u32, info.jited_prog_len, ulen);
 
@@ -3142,7 +3144,7 @@ static int bpf_prog_get_info_by_fd(struc
 	ulen = info.nr_jited_ksyms;
 	info.nr_jited_ksyms = prog->aux->func_cnt ? : 1;
 	if (ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			unsigned long ksym_addr;
 			u64 __user *user_ksyms;
 			u32 i;
@@ -3173,7 +3175,7 @@ static int bpf_prog_get_info_by_fd(struc
 	ulen = info.nr_jited_func_lens;
 	info.nr_jited_func_lens = prog->aux->func_cnt ? : 1;
 	if (ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			u32 __user *user_lens;
 			u32 func_len, i;
 
@@ -3230,7 +3232,7 @@ static int bpf_prog_get_info_by_fd(struc
 	else
 		info.nr_jited_line_info = 0;
 	if (info.nr_jited_line_info && ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			__u64 __user *user_linfo;
 			u32 i;
 
@@ -3276,7 +3278,8 @@ done:
 	return 0;
 }
 
-static int bpf_map_get_info_by_fd(struct bpf_map *map,
+static int bpf_map_get_info_by_fd(struct file *file,
+				  struct bpf_map *map,
 				  const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
@@ -3319,7 +3322,8 @@ static int bpf_map_get_info_by_fd(struct
 	return 0;
 }
 
-static int bpf_btf_get_info_by_fd(struct btf *btf,
+static int bpf_btf_get_info_by_fd(struct file *file,
+				  struct btf *btf,
 				  const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
@@ -3351,13 +3355,13 @@ static int bpf_obj_get_info_by_fd(const
 		return -EBADFD;
 
 	if (f.file->f_op == &bpf_prog_fops)
-		err = bpf_prog_get_info_by_fd(f.file->private_data, attr,
+		err = bpf_prog_get_info_by_fd(f.file, f.file->private_data, attr,
 					      uattr);
 	else if (f.file->f_op == &bpf_map_fops)
-		err = bpf_map_get_info_by_fd(f.file->private_data, attr,
+		err = bpf_map_get_info_by_fd(f.file, f.file->private_data, attr,
 					     uattr);
 	else if (f.file->f_op == &btf_fops)
-		err = bpf_btf_get_info_by_fd(f.file->private_data, attr, uattr);
+		err = bpf_btf_get_info_by_fd(f.file, f.file->private_data, attr, uattr);
 	else
 		err = -EINVAL;
 
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -277,7 +277,7 @@ static int proc_dointvec_minmax_bpf_enab
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 	if (write && !ret) {
 		if (jit_enable < 2 ||
-		    (jit_enable == 2 && bpf_dump_raw_ok())) {
+		    (jit_enable == 2 && bpf_dump_raw_ok(current_cred()))) {
 			*(int *)table->data = jit_enable;
 			if (jit_enable == 2)
 				pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");


