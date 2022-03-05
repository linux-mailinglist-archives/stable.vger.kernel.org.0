Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50CE4CE703
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 21:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiCEUio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 15:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiCEUio (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 15:38:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E9D624E
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B11B80CAE
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 20:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1FCC004E1;
        Sat,  5 Mar 2022 20:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646512670;
        bh=BjaKZXgkSalbanR0UgFCT61O41TEWbqZQEpysTNeIos=;
        h=Subject:To:Cc:From:Date:From;
        b=R0qvQhumYgUCy/2As2UuCrLhTTmx6sAhnsIutOPXkfAhJe1FgfyHnhIyqAgwSw9Uz
         GFfzOxj5+OiKC1xgFhEtdUE3iytAzqL8x5GLzOP7XZUpHDYucOhoX5+N4PoOWzvaf3
         A8Xf8sNt4m8JSWgX6v/VQ+wYRwnclU19qCKExcMA=
Subject: FAILED: patch "[PATCH] s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE" failed to apply to 5.15-stable tree
To:     egorenar@linux.ibm.com, gor@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 21:37:47 +0100
Message-ID: <1646512667134221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b4b54c7ca347bcb4aa7a3cc01aa16e84ac7fbe4 Mon Sep 17 00:00:00 2001
From: Alexander Egorenkov <egorenar@linux.ibm.com>
Date: Wed, 9 Feb 2022 11:25:09 +0100
Subject: [PATCH] s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE

We need to preserve the values at OLDMEM_BASE and OLDMEM_SIZE which are
used by zgetdump in case when kdump crashes. In that case zgetdump will
attempt to read OLDMEM_BASE and OLDMEM_SIZE in order to find out where
the memory range [0 - OLDMEM_SIZE] belonging to the production kernel is.

Fixes: f1a546947431 ("s390/setup: don't reserve memory that occupied decompressor's head")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f2c25d113e7b..05327be3a982 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -800,6 +800,8 @@ static void __init check_initrd(void)
 static void __init reserve_kernel(void)
 {
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
+	memblock_reserve(OLDMEM_BASE, sizeof(unsigned long));
+	memblock_reserve(OLDMEM_SIZE, sizeof(unsigned long));
 	memblock_reserve(__amode31_base, __eamode31 - __samode31);
 	memblock_reserve(__pa(sclp_early_sccb), EXT_SCCB_READ_SCP);
 	memblock_reserve(__pa(_stext), _end - _stext);

