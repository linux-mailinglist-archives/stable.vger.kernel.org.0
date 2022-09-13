Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3465B7101
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiIMOmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiIMOlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E61D6DAE1;
        Tue, 13 Sep 2022 07:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A950614C1;
        Tue, 13 Sep 2022 14:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B08C433C1;
        Tue, 13 Sep 2022 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078855;
        bh=C/HDZ6JjjGmV0Muuso1uMKjhiELoFUQN4W/GK07HmlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYwvkHI8Mofsa9Vfyc0sUVx8w8El2iP/z69SH4qGJqcrTARG3OJUJPGcP06IrgY3o
         7IPGcclt4MV1R0AfPYNUzWS7W3zipT2myFraUz5rMlXR4JkEjjxVvE1EaRBvfYS3Lx
         zW4mCA/aoCcnGJ8+uJDqMqRTXmDoUPez2Ngsujw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/121] s390/boot: fix absolute zero lowcore corruption on boot
Date:   Tue, 13 Sep 2022 16:05:00 +0200
Message-Id: <20220913140402.029966827@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 12dd19c159659ec9050f45dc8a2ff3c3917f4be3 ]

Crash dump always starts on CPU0. In case CPU0 is offline the
prefix page is not installed and the absolute zero lowcore is
used. However, struct lowcore::mcesad is never assigned and
stays zero. That leads to __machine_kdump() -> save_vx_regs()
call silently stores vector registers to the absolute lowcore
at 0x11b0 offset.

Fixes: a62bc0739253 ("s390/kdump: add support for vector extension")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/nmi.c   | 2 +-
 arch/s390/kernel/setup.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index a50f2ff1b00e8..383b4799b6dd3 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -62,7 +62,7 @@ static inline unsigned long nmi_get_mcesa_size(void)
  * The structure is required for machine check happening early in
  * the boot process.
  */
-static struct mcesa boot_mcesa __initdata __aligned(MCESA_MAX_SIZE);
+static struct mcesa boot_mcesa __aligned(MCESA_MAX_SIZE);
 
 void __init nmi_alloc_boot_cpu(struct lowcore *lc)
 {
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 6b1a8697fae8d..4dfe37b068898 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -484,6 +484,7 @@ static void __init setup_lowcore_dat_off(void)
 	put_abs_lowcore(restart_data, lc->restart_data);
 	put_abs_lowcore(restart_source, lc->restart_source);
 	put_abs_lowcore(restart_psw, lc->restart_psw);
+	put_abs_lowcore(mcesad, lc->mcesad);
 
 	lc->spinlock_lockval = arch_spin_lockval(0);
 	lc->spinlock_index = 0;
-- 
2.35.1



