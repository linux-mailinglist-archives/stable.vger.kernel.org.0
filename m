Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887E4246A29
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgHQPbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgHQPbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464352245C;
        Mon, 17 Aug 2020 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678268;
        bh=puuZK4Hc/ru+F/LefG+5ZC9v99mVnZgP2MsXOFegl9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDuHtfXDDkoW0gR51mirMoKE5vsHd2mKqeAtdJjTOhdBGCw7uOLWaEMmnj2hUlwCt
         Rp3OcEL/ZUUUaJjrJ+PdbQajnOvivTktYKJlGvQvZAPCM8rBzYq7e/eV7YlXZlfMnU
         joz+mtmj9IMYalzrScdBbUxdIfgG6flGZV/W/vRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 275/464] s390/bpf: Use brcl for jumping to exit_ip if necessary
Date:   Mon, 17 Aug 2020 17:13:48 +0200
Message-Id: <20200817143846.943990302@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 6b3d612948fba..6b8968f6e207d 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1268,8 +1268,12 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
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



