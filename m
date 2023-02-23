Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D486A09BC
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbjBWNJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjBWNJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F01D5FCE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E046616EC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F953C433EF;
        Thu, 23 Feb 2023 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157779;
        bh=FAvQz87F194rThrz5e7/TWrFIjr0ko8YEiQ+9ws5R8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJG9ymkvo/syVfHgcdc8doHVjd1cAhJ+40UpKjfSNi8IZJAhSZwT39hymgOQhM1i/
         hroD0Dy7W6V+c03w9BO5uhXksPEmSe+jQx+s8Oe239P0d/xgz5iekMMcMIgcitkC+z
         zxqjDQr0KxiXCpltDUsNRRwhcE5T5WJfdR8lIms4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 6.1 34/46] riscv: remove special treatment for the link order of head.o
Date:   Thu, 23 Feb 2023 14:06:41 +0100
Message-Id: <20230223130433.179552395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

commit 2348e6bf44213c5f447ff698e43c089185241ed7 upstream.

arch/riscv/kernel/head.o does not need any special treatment - the only
requirement is the ".head.text" section must be placed before the
normal ".text" section.

The linker script does the right thing to do. The build system does
not need to manipulate the link order of head.o.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221018141200.1040-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/head-object-list.txt |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/head-object-list.txt
+++ b/scripts/head-object-list.txt
@@ -39,7 +39,6 @@ arch/powerpc/kernel/entry_64.o
 arch/powerpc/kernel/fpu.o
 arch/powerpc/kernel/vector.o
 arch/powerpc/kernel/prom_init.o
-arch/riscv/kernel/head.o
 arch/s390/kernel/head64.o
 arch/sh/kernel/head_32.o
 arch/sparc/kernel/head_32.o


