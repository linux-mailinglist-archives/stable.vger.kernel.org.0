Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A549BD243C
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbfJJIu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389182AbfJJIu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1682064A;
        Thu, 10 Oct 2019 08:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697427;
        bh=A//ZPAlE2EI3za0ZG5iva94it8p6T10S0n2ElkIB3S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6S1rWS3vo6rJ/YYGMfmi8yRyOKsCSinz8y+vr2njXXpiDN373unVYeeZ3D0GaQ7s
         bbXdl1WQLQtXGpn5tciZHxpgm+9b9iM24f7LY8CGgP7bPQo5ntJM94xABkApuPW5Tx
         686qqT+OeFe1IHujhYy1lPVAnZ0XqYQxSxRB5mJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 03/61] s390/topology: avoid firing events before kobjs are created
Date:   Thu, 10 Oct 2019 10:36:28 +0200
Message-Id: <20191010083451.169726731@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -300,7 +300,8 @@ int arch_update_cpu_topology(void)
 	rc = __arch_update_cpu_topology();
 	for_each_online_cpu(cpu) {
 		dev = get_cpu_device(cpu);
-		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+		if (dev)
+			kobject_uevent(&dev->kobj, KOBJ_CHANGE);
 	}
 	return rc;
 }


