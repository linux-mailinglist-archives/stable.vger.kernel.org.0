Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD81E2E50
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391585AbgEZT2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390174AbgEZTC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB5D2086A;
        Tue, 26 May 2020 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519777;
        bh=2dV8kWIG71SiZs/1feT2OKCo8EG/g/GDwpQxqM/As9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ef54Y5gj0GfxdNhWAS3W/7FN8X4VYeRHJlWGsR5KQnpeZ9eiIui37DhIWwus2QC3y
         DrHgVOt3pe48EO9mMdwmQVPJIi/zmZ6Xtg/T/8QsptFLMXEf9GTC0IZ0RitT1oY+K8
         1rKlyatwTk7mdHmplw3JCx+3C98TsJqh+PBuQbMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>,
        Yash Shah <yash.shah@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 4.19 05/81] riscv: set max_pfn to the PFN of the last page
Date:   Tue, 26 May 2020 20:52:40 +0200
Message-Id: <20200526183924.534086347@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

commit c749bb2d554825e007cbc43b791f54e124dadfce upstream.

The current max_pfn equals to zero. In this case, I found it caused users
cannot get some page information through /proc such as kpagecount in v5.6
kernel because of new sanity checks. The following message is displayed by
stress-ng test suite with the command "stress-ng --verbose --physpage 1 -t
1" on HiFive unleashed board.

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: debug: [109] 4 processors online, 4 processors configured
 stress-ng: info: [109] dispatching hogs: 1 physpage
 stress-ng: debug: [109] cache allocate: reducing cache level from L3 (too high) to L0
 stress-ng: debug: [109] get_cpu_cache: invalid cache_level: 0
 stress-ng: info: [109] cache allocate: using built-in defaults as no suitable cache found
 stress-ng: debug: [109] cache allocate: default cache size: 2048K
 stress-ng: debug: [109] starting stressors
 stress-ng: debug: [109] 1 stressor spawned
 stress-ng: debug: [110] stress-ng-physpage: started [110] (instance 0)
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd34de000 in /proc/kpagecount, errno=0 (Success)
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
 ...
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
 stress-ng: debug: [110] stress-ng-physpage: exited [110] (instance 0)
 stress-ng: debug: [109] process [110] terminated
 stress-ng: info: [109] successful run completed in 1.00s
 #

After applying this patch, the kernel can pass the test.

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: debug: [104] 4 processors online, 4 processors configured stress-ng: info: [104] dispatching hogs: 1 physpage
 stress-ng: info: [104] cache allocate: using defaults, can't determine cache details from sysfs
 stress-ng: debug: [104] cache allocate: default cache size: 2048K
 stress-ng: debug: [104] starting stressors
 stress-ng: debug: [104] 1 stressor spawned
 stress-ng: debug: [105] stress-ng-physpage: started [105] (instance 0) stress-ng: debug: [105] stress-ng-physpage: exited [105] (instance 0) stress-ng: debug: [104] process [105] terminated
 stress-ng: info: [104] successful run completed in 1.01s
 #

Cc: stable@vger.kernel.org
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Tested-by: Yash Shah <yash.shah@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
[Palmer: back-ported to 4.19]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -19,6 +19,7 @@
  * to the Free Software Foundation, Inc.,
  */
 
+#include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/memblock.h>
@@ -187,6 +188,7 @@ static void __init setup_bootmem(void)
 
 	set_max_mapnr(PFN_DOWN(mem_size));
 	max_low_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_pfn = max_low_pfn;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();


