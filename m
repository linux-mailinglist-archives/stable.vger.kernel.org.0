Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A84D8339
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiCNMM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbiCNMKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7F731905;
        Mon, 14 Mar 2022 05:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F6206130D;
        Mon, 14 Mar 2022 12:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E43C340E9;
        Mon, 14 Mar 2022 12:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259772;
        bh=5gcNE94LCCJg96Ptvt+4Y5dkSMYxQpO2+YYXxIfQdUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki2HN3p8cP/HJEZ23lonFUGxaVfDNFFeKnHE0HBuveI8SMsTEutMCbr8KfOEBF/an
         Mk8V1iNy3sgqqgL3D8UA9oELUWO8RL/AKjAFsxe6BXPMiALpNFkz32HsyqFWEYZ3BL
         42ZRc0ESB4drq4bcb9aABs1q2EstqgzWZ+R89D78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Semel <paul.semel@datadoghq.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 086/110] arm64: kasan: fix include error in MTE functions
Date:   Mon, 14 Mar 2022 12:54:28 +0100
Message-Id: <20220314112745.431804579@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Semel <semelpaul@gmail.com>

commit b859ebedd1e730bbda69142fca87af4e712649a1 upstream.

Fix `error: expected string literal in 'asm'`.
This happens when compiling an ebpf object file that includes
`net/net_namespace.h` from linux kernel headers.

Include trace:
     include/net/net_namespace.h:10
     include/linux/workqueue.h:9
     include/linux/timer.h:8
     include/linux/debugobjects.h:6
     include/linux/spinlock.h:90
     include/linux/workqueue.h:9
     arch/arm64/include/asm/spinlock.h:9
     arch/arm64/include/generated/asm/qrwlock.h:1
     include/asm-generic/qrwlock.h:14
     arch/arm64/include/asm/processor.h:33
     arch/arm64/include/asm/kasan.h:9
     arch/arm64/include/asm/mte-kasan.h:45
     arch/arm64/include/asm/mte-def.h:14

Signed-off-by: Paul Semel <paul.semel@datadoghq.com>
Fixes: 2cb34276427a ("arm64: kasan: simplify and inline MTE functions")
Cc: <stable@vger.kernel.org> # 5.12.x
Link: https://lore.kernel.org/r/bacb5387-2992-97e4-0c48-1ed925905bee@gmail.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mte-kasan.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -5,6 +5,7 @@
 #ifndef __ASM_MTE_KASAN_H
 #define __ASM_MTE_KASAN_H
 
+#include <asm/compiler.h>
 #include <asm/mte-def.h>
 
 #ifndef __ASSEMBLY__


