Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655374CFA00
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbiCGKMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242477AbiCGKLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410C08A336;
        Mon,  7 Mar 2022 01:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C98D0B8102B;
        Mon,  7 Mar 2022 09:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FB2C340F3;
        Mon,  7 Mar 2022 09:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646862;
        bh=vAzPU0RMvCJ3eQY+a9D1Cl8N9paMO2XcoBFihnqbTq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9fZRb8Q0AsL5pgjGCsaxnzjp2JoRe62GEgx+vuxx6eDhtQQXcBnsSzxahujC3Mrc
         yhpLrwTFUiAIYX4HsnxZ9kiq2BsVnPtVWTZTFIvEYXh0KjpH6L7kjdUz0piy2Jaq6P
         0jMVGUW/ckIwmG2/NvV9h2+z1pHgk0MyU5nCnUEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.16 117/186] s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE
Date:   Mon,  7 Mar 2022 10:19:15 +0100
Message-Id: <20220307091657.349928177@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 6b4b54c7ca347bcb4aa7a3cc01aa16e84ac7fbe4 upstream.

We need to preserve the values at OLDMEM_BASE and OLDMEM_SIZE which are
used by zgetdump in case when kdump crashes. In that case zgetdump will
attempt to read OLDMEM_BASE and OLDMEM_SIZE in order to find out where
the memory range [0 - OLDMEM_SIZE] belonging to the production kernel is.

Fixes: f1a546947431 ("s390/setup: don't reserve memory that occupied decompressor's head")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

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


