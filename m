Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2BB8739
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393413AbfISWIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393410AbfISWIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8793421920;
        Thu, 19 Sep 2019 22:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930903;
        bh=VCqD+zpgTPlJpeIXx3HdQ9BeStIBLvtyglC5qFeJWV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFFs6PJK2jLxtRI6/BkknSI4ys7Dyw5oMK6p732MI/onwTjZHvTg3ilXeLM9ipABH
         MgIkzjpx2hctDiTr7zsE6XOT/IkGHY6FNLV97b9RPVnn5hcZ32OkIlJgxIRyCljKLa
         jkMCNpKC3ULf9EMQj4vuHxYRnYr9wU586bHuAOlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 056/124] selftests/bpf: fix test_cgroup_storage on s390
Date:   Fri, 20 Sep 2019 00:02:24 +0200
Message-Id: <20190919214821.039845053@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 806ce6e2117a42528e7bb979e04e28229b34a612 ]

test_cgroup_storage fails on s390 with an assertion failure: packets are
dropped when they shouldn't. The problem is that BPF_DW packet count is
accessed as BPF_W with an offset of 0, which is not correct on
big-endian machines.

Since the point of this test is not to verify narrow loads/stores,
simply use BPF_DW when working with packet counts.

Fixes: 68cfa3ac6b8d ("selftests/bpf: add a cgroup storage test")
Fixes: 919646d2a3a9 ("selftests/bpf: extend the storage test to test per-cpu cgroup storage")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_cgroup_storage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index 2fc4625c1a150..6557290043911 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -20,9 +20,9 @@ int main(int argc, char **argv)
 		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
 		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 			     BPF_FUNC_get_local_storage),
-		BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_0, 0),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0),
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 0x1),
-		BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_3, 0),
+		BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_3, 0),
 
 		BPF_LD_MAP_FD(BPF_REG_1, 0), /* map fd */
 		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
@@ -30,7 +30,7 @@ int main(int argc, char **argv)
 			     BPF_FUNC_get_local_storage),
 		BPF_MOV64_IMM(BPF_REG_1, 1),
 		BPF_STX_XADD(BPF_DW, BPF_REG_0, BPF_REG_1, 0),
-		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
 		BPF_ALU64_IMM(BPF_AND, BPF_REG_1, 0x1),
 		BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
-- 
2.20.1



