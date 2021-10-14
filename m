Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7AD42DCAF
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhJNPA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhJNO7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66176611C7;
        Thu, 14 Oct 2021 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223456;
        bh=aKU+BkwunbYlLzIK2sY1+Y9UdmvTeIh94Oqc4XSaCIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi+utLVMlKeSujgXUOvRwDXE4nzgAQVqwcD/ZFOSb/lVnbRgNUP+AiXdArJGZtTo/
         r6MbDYWl1ZL1K31EF2tzPg5SIdSelp/n4BWTkeZJjDI1wxH2bz62Bnx9voFCe20uYL
         bcnQX/34tj1rjhB56DoO9OB7WwuogOS/pPyl7ySQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 09/33] bpf: add also cbpf long jump test cases with heavy expansion
Date:   Thu, 14 Oct 2021 16:53:41 +0200
Message-Id: <20211014145209.087095680@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit be08815c5d3b25e53cd9b53a4d768d5f3d93ba25 upstream.

We have one triggering on eBPF but lets also add a cBPF example to
make sure we keep tracking them. Also add anther cBPF test running
max number of MSH ops.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_bpf.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -355,6 +355,52 @@ static int bpf_fill_maxinsns11(struct bp
 	return __bpf_fill_ja(self, BPF_MAXINSNS, 68);
 }
 
+static int bpf_fill_maxinsns12(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[0] = __BPF_JUMP(BPF_JMP | BPF_JA, len - 2, 0, 0);
+
+	for (i = 1; i < len - 1; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_K, 0xabababab);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
+static int bpf_fill_maxinsns13(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	for (i = 0; i < len - 3; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 3] = __BPF_STMT(BPF_LD | BPF_IMM, 0xabababab);
+	insn[len - 2] = __BPF_STMT(BPF_ALU | BPF_XOR | BPF_X, 0);
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_A, 0);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
 static int bpf_fill_ja(struct bpf_test *self)
 {
 	/* Hits exactly 11 passes on x86_64 JIT. */
@@ -5438,6 +5484,23 @@ static struct bpf_test tests[] = {
 		.expected_errcode = -ENOTSUPP,
 	},
 	{
+		"BPF_MAXINSNS: jump over MSH",
+		{ },
+		CLASSIC | FLAG_EXPECTED_FAIL,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xabababab } },
+		.fill_helper = bpf_fill_maxinsns12,
+		.expected_errcode = -EINVAL,
+	},
+	{
+		"BPF_MAXINSNS: exec all MSH",
+		{ },
+		CLASSIC,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xababab83 } },
+		.fill_helper = bpf_fill_maxinsns13,
+	},
+	{
 		"BPF_MAXINSNS: ld_abs+get_processor_id",
 		{ },
 		CLASSIC,


