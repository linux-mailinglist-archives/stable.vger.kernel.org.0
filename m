Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335E91A137
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 18:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfEJQTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 12:19:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38196 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfEJQTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 12:19:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id 10so3484184pfo.5
        for <stable@vger.kernel.org>; Fri, 10 May 2019 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPVJ8L16MG5ZkQywmwtT/jpvOB4on8a/lfCsY0Fi8iM=;
        b=XdZ3w+D3IcJzDccxycFTRfzUgUYCXE9/3xr6DYVxHIxRo4hhtA6UKuqK1G+eWk7m1u
         TabnLg8Mbiic7MRCIlLm8j96M5yZE3fJ+K6QDg5lnWBCJ5+rjnUj1XEWYu8nei8sSUEw
         2euUVCY3ObryaROHSl1TbYurIPRXLfWdZjt/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPVJ8L16MG5ZkQywmwtT/jpvOB4on8a/lfCsY0Fi8iM=;
        b=imZYCBh5pL37QyADLn7Jmw1GXatEw9CuEwcAwgkWZtaNNutahu1TVOQ0ee6488oFbY
         WjKXN8K7CfbaBextMpcpVY9Zo1Rvlkoh7EZHSxtMjtShJc8TPxH2LQPnnIqQUQ0xxbR+
         /i1dLGtlTjFScd06K1DP282qABPoQggfXR4FtHm9yXZAFC+4+TqEmtR/YfEV4/dEQKs0
         V9lNUOvbH5k73hbf1EFwFj3PBwqjdZWuwLNmwJG8z0+EnhH3Ck0+HoI8/u2nCqBykg2v
         qQOUSBshDtKy5HAER9rtTiNrrYgJZFRxX7JjBNqJhALMhzdYmSxyLhB6Vikof7t3p217
         A4yQ==
X-Gm-Message-State: APjAAAV6gtaRS1lN0RNWTA2htgPHBESut13LMC13KBqaruVUW8hVxpy7
        XRbD9pGTcubsuhj9W4dCeH6yejKXyaQ=
X-Google-Smtp-Source: APXvYqyuo/yxGlktP083dV55X+ibiAdQxpuH4PCL4HFJ8ZsAuJk+zV5/4qt9A2QI9ljgfm9QoX+yCg==
X-Received: by 2002:a62:1a0d:: with SMTP id a13mr15447381pfa.198.1557505176558;
        Fri, 10 May 2019 09:19:36 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id h6sm15847868pfk.188.2019.05.10.09.19.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 09:19:35 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        fruggeri@arista.com, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, davem@davemloft.net
Subject: [PATCH v4.14.y] netfilter: compat: initialize all fields in xt_init
Date:   Fri, 10 May 2019 09:19:30 -0700
Message-Id: <20190510161930.182336-1-zsm@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

commit 8d29d16d21342a0c86405d46de0c4ac5daf1760f upstream

If a non zero value happens to be in xt[NFPROTO_BRIDGE].cur at init
time, the following panic can be caused by running

% ebtables -t broute -F BROUTING

from a 32-bit user level on a 64-bit kernel. This patch replaces
kmalloc_array with kcalloc when allocating xt.

[  474.680846] BUG: unable to handle kernel paging request at 0000000009600920
[  474.687869] PGD 2037006067 P4D 2037006067 PUD 2038938067 PMD 0
[  474.693838] Oops: 0000 [#1] SMP
[  474.697055] CPU: 9 PID: 4662 Comm: ebtables Kdump: loaded Not tainted 4.19.17-11302235.AroraKernelnext.fc18.x86_64 #1
[  474.707721] Hardware name: Supermicro X9DRT/X9DRT, BIOS 3.0 06/28/2013
[  474.714313] RIP: 0010:xt_compat_calc_jump+0x2f/0x63 [x_tables]
[  474.720201] Code: 40 0f b6 ff 55 31 c0 48 6b ff 70 48 03 3d dc 45 00 00 48 89 e5 8b 4f 6c 4c 8b 47 60 ff c9 39 c8 7f 2f 8d 14 08 d1 fa 48 63 fa <41> 39 34 f8 4c 8d 0c fd 00 00 00 00 73 05 8d 42 01 eb e1 76 05 8d
[  474.739023] RSP: 0018:ffffc9000943fc58 EFLAGS: 00010207
[  474.744296] RAX: 0000000000000000 RBX: ffffc90006465000 RCX: 0000000002580249
[  474.751485] RDX: 00000000012c0124 RSI: fffffffff7be17e9 RDI: 00000000012c0124
[  474.758670] RBP: ffffc9000943fc58 R08: 0000000000000000 R09: ffffffff8117cf8f
[  474.765855] R10: ffffc90006477000 R11: 0000000000000000 R12: 0000000000000001
[  474.773048] R13: 0000000000000000 R14: ffffc9000943fcb8 R15: ffffc9000943fcb8
[  474.780234] FS:  0000000000000000(0000) GS:ffff88a03f840000(0063) knlGS:00000000f7ac7700
[  474.788612] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  474.794632] CR2: 0000000009600920 CR3: 0000002037422006 CR4: 00000000000606e0
[  474.802052] Call Trace:
[  474.804789]  compat_do_replace+0x1fb/0x2a3 [ebtables]
[  474.810105]  compat_do_ebt_set_ctl+0x69/0xe6 [ebtables]
[  474.815605]  ? try_module_get+0x37/0x42
[  474.819716]  compat_nf_setsockopt+0x4f/0x6d
[  474.824172]  compat_ip_setsockopt+0x7e/0x8c
[  474.828641]  compat_raw_setsockopt+0x16/0x3a
[  474.833220]  compat_sock_common_setsockopt+0x1d/0x24
[  474.838458]  __compat_sys_setsockopt+0x17e/0x1b1
[  474.843343]  ? __check_object_size+0x76/0x19a
[  474.847960]  __ia32_compat_sys_socketcall+0x1cb/0x25b
[  474.853276]  do_fast_syscall_32+0xaf/0xf6
[  474.857548]  entry_SYSENTER_compat+0x6b/0x7a

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
Notes:
* Syzkaller triggered a GPF in xt_compat_calc_jump with the following
stacktrace when fuzzing a 4.14 kernel.
Call Trace:
 compat_do_replace+0x5e3/0x7d0 net/bridge/netfilter/ebtables.c:2334
 compat_do_ebt_set_ctl+0x264/0x2e2 net/bridge/netfilter/ebtables.c:2383
 compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
 compat_nf_setsockopt+0x90/0x130 net/netfilter/nf_sockopt.c:156
 compat_ip_setsockopt net/ipv4/ip_sockglue.c:1281 [inline]
 compat_ip_setsockopt+0xb5/0xf0 net/ipv4/ip_sockglue.c:1262
 inet_csk_compat_setsockopt+0x9e/0x130 net/ipv4/inet_connection_sock.c:1047
 compat_tcp_setsockopt+0x45/0x80 net/ipv4/tcp.c:2816
 compat_sock_common_setsockopt+0xb9/0x150 net/core/sock.c:3017
 C_SYSC_setsockopt net/compat.c:404 [inline]
 compat_SyS_setsockopt+0x14a/0x390 net/compat.c:387
 do_syscall_32_irqs_on arch/x86/entry/common.c:349 [inline]
 do_fast_syscall_32+0x3b4/0xc90 arch/x86/entry/common.c:412
 entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139

* This patch resolves a conflict that arises when applying the original
upstream commit. The conflict arises as the following upstream commit is
not present in v4.14.y.
    6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()")

* This commit is present in linux-4.19.y

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8e054c63b54e..d42211a0b5e3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1798,7 +1798,7 @@ static int __init xt_init(void)
 		seqcount_init(&per_cpu(xt_recseq, i));
 	}
 
-	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
+	xt = kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
 	if (!xt)
 		return -ENOMEM;
 
-- 
2.21.0.1020.gf2820cf01a-goog

