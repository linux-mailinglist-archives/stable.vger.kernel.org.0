Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBADA137E81
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAKKKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbgAKKKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:10:41 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B602084D;
        Sat, 11 Jan 2020 10:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737440;
        bh=VVAXxor+iPN+v/i1b9zhPl8bSbTs/m3d8lkUIp2osCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbjNm3bThSrY34sRgiV0gkqlza7T9Ygkq6VUAOPoMbaA1hTGjl2eDKQcLi6BGvOB/
         VGc16VcucA2AFK1fgYeQkdNUfkAhF3DgEQGSItY30H/B1Ueb54V0LgX/WqJISAAo1+
         /0HH/OrtCL2nBO/Paipyaypa8UeRqVSLGRj7j5kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/62] samples: bpf: fix syscall_tp due to unused syscall
Date:   Sat, 11 Jan 2020 10:50:03 +0100
Message-Id: <20200111094844.096095095@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit fe3300897cbfd76c6cb825776e5ac0ca50a91ca4 ]

Currently, open() is called from the user program and it calls the syscall
'sys_openat', not the 'sys_open'. This leads to an error of the program
of user side, due to the fact that the counter maps are zero since no
function such 'sys_open' is called.

This commit adds the kernel bpf program which are attached to the
tracepoint 'sys_enter_openat' and 'sys_enter_openat'.

Fixes: 1da236b6be963 ("bpf: add a test case for syscalls/sys_{enter|exit}_* tracepoints")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/syscall_tp_kern.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 9149c524d279..8833aacb9c8c 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -50,13 +50,27 @@ static __always_inline void count(void *map)
 SEC("tracepoint/syscalls/sys_enter_open")
 int trace_enter_open(struct syscalls_enter_open_args *ctx)
 {
-	count((void *)&enter_open_map);
+	count(&enter_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_enter_openat")
+int trace_enter_open_at(struct syscalls_enter_open_args *ctx)
+{
+	count(&enter_open_map);
 	return 0;
 }
 
 SEC("tracepoint/syscalls/sys_exit_open")
 int trace_enter_exit(struct syscalls_exit_open_args *ctx)
 {
-	count((void *)&exit_open_map);
+	count(&exit_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_exit_openat")
+int trace_enter_exit_at(struct syscalls_exit_open_args *ctx)
+{
+	count(&exit_open_map);
 	return 0;
 }
-- 
2.20.1



