Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD5945244B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357098AbhKPBhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242885AbhKOSrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:47:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924C063394;
        Mon, 15 Nov 2021 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999659;
        bh=FJgi0X6NyIL0I6Kq38gj1W8prcVyVQSF2ax9B3/W0Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhiIWVqiOdWmpSkVMjV2h6r4iNE00WT7yJk9N/05sSnQ/v7PuBHEsr/zj07XciQ5n
         fwcw2idcVoNDitEoUQIglETLIWm9bo+Su4CQLyf3/J2yz68WGQ38efacscUiLy+xz0
         EPt2lN0JRem+yMLX6TzsHFsopyVP3EVq9PfM28Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 377/849] libbpf: Fix skel_internal.h to set errno on loader retval < 0
Date:   Mon, 15 Nov 2021 17:57:40 +0100
Message-Id: <20211115165432.990583527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit e68ac0082787f4e8ee6ae5b19076ec7709ce715b ]

When the loader indicates an internal error (result of a checked bpf
system call), it returns the result in attr.test.retval. However, tests
that rely on ASSERT_OK_PTR on NULL (returned from light skeleton) may
miss that NULL denotes an error if errno is set to 0. This would result
in skel pointer being NULL, while ASSERT_OK_PTR returning 1, leading to
a SEGV on dereference of skel, because libbpf_get_error relies on the
assumption that errno is always set in case of error for ptr == NULL.

In particular, this was observed for the ksyms_module test. When
executed using `./test_progs -t ksyms`, prior tests manipulated errno
and the test didn't crash when it failed at ksyms_module load, while
using `./test_progs -t ksyms_module` crashed due to errno being
untouched.

Fixes: 67234743736a (libbpf: Generate loader program out of BPF ELF file.)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210927145941.1383001-11-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/skel_internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index b22b50c1b173e..9cf66702fa8dd 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -105,10 +105,12 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 	err = skel_sys_bpf(BPF_PROG_RUN, &attr, sizeof(attr));
 	if (err < 0 || (int)attr.test.retval < 0) {
 		opts->errstr = "failed to execute loader prog";
-		if (err < 0)
+		if (err < 0) {
 			err = -errno;
-		else
+		} else {
 			err = (int)attr.test.retval;
+			errno = -err;
+		}
 		goto out;
 	}
 	err = 0;
-- 
2.33.0



