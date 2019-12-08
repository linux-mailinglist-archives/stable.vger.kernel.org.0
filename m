Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDC511620D
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfLHN5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60220 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbfLHNyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0007eh-8d; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0002Nc-5D; Sun, 08 Dec 2019 13:54:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date:   Sun, 08 Dec 2019 13:53:24 +0000
Message-ID: <lsq.1575813165.135600170@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 40/72] s390/topology: avoid firing events before
 kobjs are created
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit f3122a79a1b0a113d3aea748e0ec26f2cb2889de upstream.

arch_update_cpu_topology is first called from:
kernel_init_freeable->sched_init_smp->sched_init_domains

even before cpus has been registered in:
kernel_init_freeable->do_one_initcall->s390_smp_init

Do not trigger kobject_uevent change events until cpu devices are
actually created. Fixes the following kasan findings:

BUG: KASAN: global-out-of-bounds in kobject_uevent_env+0xb40/0xee0
Read of size 8 at addr 0000000000000020 by task swapper/0/1

BUG: KASAN: global-out-of-bounds in kobject_uevent_env+0xb36/0xee0
Read of size 8 at addr 0000000000000018 by task swapper/0/1

CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B
Hardware name: IBM 3906 M04 704 (LPAR)
Call Trace:
([<0000000143c6db7e>] show_stack+0x14e/0x1a8)
 [<0000000145956498>] dump_stack+0x1d0/0x218
 [<000000014429fb4c>] print_address_description+0x64/0x380
 [<000000014429f630>] __kasan_report+0x138/0x168
 [<0000000145960b96>] kobject_uevent_env+0xb36/0xee0
 [<0000000143c7c47c>] arch_update_cpu_topology+0x104/0x108
 [<0000000143df9e22>] sched_init_domains+0x62/0xe8
 [<000000014644c94a>] sched_init_smp+0x3a/0xc0
 [<0000000146433a20>] kernel_init_freeable+0x558/0x958
 [<000000014599002a>] kernel_init+0x22/0x160
 [<00000001459a71d4>] ret_from_fork+0x28/0x30
 [<00000001459a71dc>] kernel_thread_starter+0x0/0x10

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -266,7 +266,8 @@ int arch_update_cpu_topology(void)
 	update_cpu_masks();
 	for_each_online_cpu(cpu) {
 		dev = get_cpu_device(cpu);
-		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+		if (dev)
+			kobject_uevent(&dev->kobj, KOBJ_CHANGE);
 	}
 	return 1;
 }

