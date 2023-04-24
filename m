Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5174A6ECD76
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjDXNXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjDXNX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C334F59DB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59413621EF
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C142C433D2;
        Mon, 24 Apr 2023 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342600;
        bh=W0+G7JCCa9E+xKCgvOsw7cNCZI/uAk2RgAcSNY+2Tr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXh6bH1FYlxeT+G8ic5VOGCej+3gxBFesa/ehcHNR5Q9PGIRNz6UUFJGpX6I383Hm
         6uhxqglnPDOzS6UA84OC+jC3ImojiyRCc5juPuQJIYiZ91wQk8jJRrEYnCDdmhNqmu
         69UpEayCeNElOpmU7zRUWTfgDEflWlx+DmCA411M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "kernelci.org bot" <bot@kernelci.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 26/39] MIPS: Define RUNTIME_DISCARD_EXIT in LD script
Date:   Mon, 24 Apr 2023 15:17:29 +0200
Message-Id: <20230424131124.054902950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 6dcbd0a69c84a8ae7a442840a8cf6b1379dc8f16 upstream.

MIPS's exit sections are discarded at runtime as well.

Fixes link error:
`.exit.text' referenced in section `__jump_table' of fs/fuse/inode.o:
defined in discarded section `.exit.text' of fs/fuse/inode.o

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -10,6 +10,8 @@
  */
 #define BSS_FIRST_SECTIONS *(.bss..swapper_pg_dir)
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips


