Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649D856FC8E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGKJpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiGKJoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68580A4CB5;
        Mon, 11 Jul 2022 02:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E27BFB80E6D;
        Mon, 11 Jul 2022 09:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ADBC34115;
        Mon, 11 Jul 2022 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531313;
        bh=aHY4s6ThFh4WFR8QECkXyGEc/WgAC0zJmGhEJyrM++M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvIl3+JXjmSfhiOnAqwimouaA75M/Jh7bU59y4fwQchgsA0FRV6ocypOq1tCKAjEW
         gvD2c+PliGxfV/ZCbjQ9rgtpiAeIuNbx/REGSszZr+ur/STunPmO6qNMOb6+GZnw5J
         B3KDwKUAs6BgUBuOofFv1UymaM0/obZ48d1lWsmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/230] s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE
Date:   Mon, 11 Jul 2022 11:05:17 +0200
Message-Id: <20220711090605.807742798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit 6b4b54c7ca347bcb4aa7a3cc01aa16e84ac7fbe4 ]

We need to preserve the values at OLDMEM_BASE and OLDMEM_SIZE which are
used by zgetdump in case when kdump crashes. In that case zgetdump will
attempt to read OLDMEM_BASE and OLDMEM_SIZE in order to find out where
the memory range [0 - OLDMEM_SIZE] belonging to the production kernel is.

Fixes: f1a546947431 ("s390/setup: don't reserve memory that occupied decompressor's head")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 2ebde341d057..36c1f31dfd66 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -798,6 +798,8 @@ static void __init check_initrd(void)
 static void __init reserve_kernel(void)
 {
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
+	memblock_reserve(OLDMEM_BASE, sizeof(unsigned long));
+	memblock_reserve(OLDMEM_SIZE, sizeof(unsigned long));
 	memblock_reserve(__amode31_base, __eamode31 - __samode31);
 	memblock_reserve(__pa(sclp_early_sccb), EXT_SCCB_READ_SCP);
 	memblock_reserve(__pa(_stext), _end - _stext);
-- 
2.35.1



