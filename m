Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFED657D32
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiL1Pkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiL1Pka (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A207167F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E37B76155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04306C433D2;
        Wed, 28 Dec 2022 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242028;
        bh=ewhZL2tHn2SOQzvBTF5or+PQfMteZJMpwQ6I7vLoelk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3+suhJuu+n05jWxUsiepj0U/wntA9cNvHfPCsT4u1JBHM0+tfhyqs0ld1mqrArdO
         XlykHqaG4h5d57h/9JC7IsExO8eZm4WE47AcS6onn0jSlJ9WSP9p0VMu93jLTeInFY
         JyBOeaID5fY0tCP1bcoDCntuNqAuBnJ2VuNyGcjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0335/1073] selftests/bpf: fix memory leak of lsm_cgroup
Date:   Wed, 28 Dec 2022 15:32:03 +0100
Message-Id: <20221228144337.102144613@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit c453e64cbc9532c0c2edfa999c35d29dad16b8bb ]

kmemleak reports this issue:

unreferenced object 0xffff88810b7835c0 (size 32):
  comm "test_progs", pid 270, jiffies 4294969007 (age 1621.315s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000376cdeab>] kmalloc_trace+0x27/0x110
    [<000000003bcdb3b6>] selinux_sk_alloc_security+0x66/0x110
    [<000000003959008f>] security_sk_alloc+0x47/0x80
    [<00000000e7bc6668>] sk_prot_alloc+0xbd/0x1a0
    [<0000000002d6343a>] sk_alloc+0x3b/0x940
    [<000000009812a46d>] unix_create1+0x8f/0x3d0
    [<000000005ed0976b>] unix_create+0xa1/0x150
    [<0000000086a1d27f>] __sock_create+0x233/0x4a0
    [<00000000cffe3a73>] __sys_socket_create.part.0+0xaa/0x110
    [<0000000007c63f20>] __sys_socket+0x49/0xf0
    [<00000000b08753c8>] __x64_sys_socket+0x42/0x50
    [<00000000b56e26b3>] do_syscall_64+0x3b/0x90
    [<000000009b4871b8>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:

unix_create1()
  sk_alloc()
    sk_prot_alloc()
      security_sk_alloc()
        call_int_hook()
          hlist_for_each_entry()
            entry1->hook.sk_alloc_security
            <-- selinux_sk_alloc_security() succeeded,
            <-- sk->security alloced here.
            entry2->hook.sk_alloc_security
            <-- bpf_lsm_sk_alloc_security() failed
      goto out_free;
        ...    <-- the sk->security not freed, memleak

The core problem is that the LSM is not yet fully stacked (work is
actively going on in this space) which means that some LSM hooks do
not support multiple LSMs at the same time. To fix, skip the
"EPERM" test when it runs in the environments that already have
non-bpf lsms installed

Fixes: dca85aac8895 ("selftests/bpf: lsm_cgroup functional test")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Cc: Stanislav Fomichev <sdf@google.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/1668482980-16163-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/lsm_cgroup.c       | 17 +++++++++++++----
 tools/testing/selftests/bpf/progs/lsm_cgroup.c  |  8 ++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
index 1102e4f42d2d..f117bfef68a1 100644
--- a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
@@ -173,10 +173,12 @@ static void test_lsm_cgroup_functional(void)
 	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
 	ASSERT_EQ(query_prog_cnt(cgroup_fd2, NULL), 1, "total prog count");
 
-	/* AF_UNIX is prohibited. */
-
 	fd = socket(AF_UNIX, SOCK_STREAM, 0);
-	ASSERT_LT(fd, 0, "socket(AF_UNIX)");
+	if (!(skel->kconfig->CONFIG_SECURITY_APPARMOR
+	    || skel->kconfig->CONFIG_SECURITY_SELINUX
+	    || skel->kconfig->CONFIG_SECURITY_SMACK))
+		/* AF_UNIX is prohibited. */
+		ASSERT_LT(fd, 0, "socket(AF_UNIX)");
 	close(fd);
 
 	/* AF_INET6 gets default policy (sk_priority). */
@@ -233,11 +235,18 @@ static void test_lsm_cgroup_functional(void)
 
 	/* AF_INET6+SOCK_STREAM
 	 * AF_PACKET+SOCK_RAW
+	 * AF_UNIX+SOCK_RAW if already have non-bpf lsms installed
 	 * listen_fd
 	 * client_fd
 	 * accepted_fd
 	 */
-	ASSERT_EQ(skel->bss->called_socket_post_create2, 5, "called_create2");
+	if (skel->kconfig->CONFIG_SECURITY_APPARMOR
+	    || skel->kconfig->CONFIG_SECURITY_SELINUX
+	    || skel->kconfig->CONFIG_SECURITY_SMACK)
+		/* AF_UNIX+SOCK_RAW if already have non-bpf lsms installed */
+		ASSERT_EQ(skel->bss->called_socket_post_create2, 6, "called_create2");
+	else
+		ASSERT_EQ(skel->bss->called_socket_post_create2, 5, "called_create2");
 
 	/* start_server
 	 * bind(ETH_P_ALL)
diff --git a/tools/testing/selftests/bpf/progs/lsm_cgroup.c b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
index 4f2d60b87b75..02c11d16b692 100644
--- a/tools/testing/selftests/bpf/progs/lsm_cgroup.c
+++ b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
@@ -7,6 +7,10 @@
 
 char _license[] SEC("license") = "GPL";
 
+extern bool CONFIG_SECURITY_SELINUX __kconfig __weak;
+extern bool CONFIG_SECURITY_SMACK __kconfig __weak;
+extern bool CONFIG_SECURITY_APPARMOR __kconfig __weak;
+
 #ifndef AF_PACKET
 #define AF_PACKET 17
 #endif
@@ -140,6 +144,10 @@ SEC("lsm_cgroup/sk_alloc_security")
 int BPF_PROG(socket_alloc, struct sock *sk, int family, gfp_t priority)
 {
 	called_socket_alloc++;
+	/* if already have non-bpf lsms installed, EPERM will cause memory leak of non-bpf lsms */
+	if (CONFIG_SECURITY_SELINUX || CONFIG_SECURITY_SMACK || CONFIG_SECURITY_APPARMOR)
+		return 1;
+
 	if (family == AF_UNIX)
 		return 0; /* EPERM */
 
-- 
2.35.1



