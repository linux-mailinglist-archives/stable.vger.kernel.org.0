Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7D247342
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbgHQSx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387820AbgHQPvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5150920729;
        Mon, 17 Aug 2020 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679508;
        bh=3TuEBXFDwH81f9PdjR3rOS4cyy+Ae7JpUowXQ+CxFCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvRNuO9W9UK6krdbgITm5IRXDWyIDcKC3cutWLebK3/IXKK3e92LkyczECtLlbZoq
         A4M7zW/VmXN2rsM/jLsZonDHHt3c7lf+bCjbY+UT6uze3Aco42nZ0W5NwdI1dNbCYJ
         cbmOqmj7PDnxZDEUbbhKhyruP6nsphsnHGBHREQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 237/393] s390/bpf: Use brcl for jumping to exit_ip if necessary
Date:   Mon, 17 Aug 2020 17:14:47 +0200
Message-Id: <20200817143831.115758811@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 5fa6974471c5518a50bdd814067508dbcb477251 ]

"BPF_MAXINSNS: Maximum possible literals" test causes panic with
bpf_jit_harden = 2. The reason is that BPF_JMP | BPF_EXIT is always
emitted as brc, however, after removal of JITed image size
limitations, brcl might be required.

Fix by using brcl when necessary.

Fixes: 4e9b4a6883dd ("s390/bpf: Use relative long branches")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200717165326.6786-4-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index ac227ea13cbe7..650b89eb693e6 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1267,8 +1267,12 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		last = (i == fp->len - 1) ? 1 : 0;
 		if (last)
 			break;
-		/* j <exit> */
-		EMIT4_PCREL(0xa7f40000, jit->exit_ip - jit->prg);
+		if (!is_first_pass(jit) && can_use_rel(jit, jit->exit_ip))
+			/* brc 0xf, <exit> */
+			EMIT4_PCREL_RIC(0xa7040000, 0xf, jit->exit_ip);
+		else
+			/* brcl 0xf, <exit> */
+			EMIT6_PCREL_RILC(0xc0040000, 0xf, jit->exit_ip);
 		break;
 	/*
 	 * Branch relative (number of skipped instructions) to offset on
-- 
2.25.1



