Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA476AEE51
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjCGSLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjCGSKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92594C6E5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852B661520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B4C433EF;
        Tue,  7 Mar 2023 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212341;
        bh=29HGd5KTll93Lf8nwVm2rZKkYRRQ+4eN2imPDMKg5kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drCLELX0YKTV06tBafqwHj+jPDlWTY1YosgDB6R+wBpF5CwW2+gU9sl1MAbUTTOG/
         HsSRlOzGuAzkd6HHA78MzjIE8MwK1fMEm+9MqIqF9arWRWFTiYiGHfgBYFCmHuuFgW
         WH8gc5xcIgIGGpxUHl5CgsFBySWduk3RKp5rx2As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/885] s390/early: fix sclp_early_sccb variable lifetime
Date:   Tue,  7 Mar 2023 17:51:29 +0100
Message-Id: <20230307170008.650944535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 639886b71ddef085a0e7bb1f225b8ae3eda5c06f ]

Commit ada1da31ce34 ("s390/sclp: sort out physical vs
virtual pointers usage") fixed the notion of virtual
address for sclp_early_sccb pointer. However, it did
not take into account that kasan_early_init() can also
output messages and sclp_early_sccb should be adjusted
by the time kasan_early_init() is called.

Currently it is not a problem, since virtual and physical
addresses on s390 are the same. Nevertheless, should they
ever differ, this would cause an invalid pointer access.

Fixes: ada1da31ce34 ("s390/sclp: sort out physical vs virtual pointers usage")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c       | 1 -
 arch/s390/kernel/head64.S      | 1 +
 drivers/s390/char/sclp_early.c | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 6030fdd6997bc..9693c8630e73f 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -288,7 +288,6 @@ static void __init sort_amode31_extable(void)
 
 void __init startup_init(void)
 {
-	sclp_early_adjust_va();
 	reset_tod_clock();
 	check_image_bootable();
 	time_early_init();
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index d7b8b6ad574dc..3b3bf8329e6c1 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -25,6 +25,7 @@ ENTRY(startup_continue)
 	larl	%r14,init_task
 	stg	%r14,__LC_CURRENT
 	larl	%r15,init_thread_union+THREAD_SIZE-STACK_FRAME_OVERHEAD-__PT_SIZE
+	brasl	%r14,sclp_early_adjust_va	# allow sclp_early_printk
 #ifdef CONFIG_KASAN
 	brasl	%r14,kasan_early_init
 #endif
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index d15b0d541de36..140d4ee29105c 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -161,7 +161,7 @@ static void __init sclp_early_console_detect(struct init_sccb *sccb)
 		sclp.has_linemode = 1;
 }
 
-void __init sclp_early_adjust_va(void)
+void __init __no_sanitize_address sclp_early_adjust_va(void)
 {
 	sclp_early_sccb = __va((unsigned long)sclp_early_sccb);
 }
-- 
2.39.2



