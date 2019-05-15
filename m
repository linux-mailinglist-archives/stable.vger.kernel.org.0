Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172A31F190
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfEOLPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730324AbfEOLPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B840B20644;
        Wed, 15 May 2019 11:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918946;
        bh=XpOimai2Y+rKhv9uw0hvWsKLu9Rnw9NKN5NfKNRH87M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM2o59wYVW0JY5N0tbzlesmYJ4ecOrfw61ldseCfK4hZJpAguzpRbTcZxcVRivhAW
         4qkP4G6694UbEY1UxZW9vaOEATBGI6VjqurvtDsjfxa5uHjkPcnZZO7r3Q8/BIrrZ2
         DOcPmPKh9+NX8tt2jSMEcqrpJLPqsnGrMMc5cAjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Zubin Mithra <zsm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 001/115] netfilter: compat: initialize all fields in xt_init
Date:   Wed, 15 May 2019 12:54:41 +0200
Message-Id: <20190515090659.251532463@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8e054c63b54e4..d42211a0b5e3b 100644
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
2.20.1



