Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA82566D20
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiGEMVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiGEMTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC6F1D312;
        Tue,  5 Jul 2022 05:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 578EC6199F;
        Tue,  5 Jul 2022 12:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595C6C341C7;
        Tue,  5 Jul 2022 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023313;
        bh=pUFp6/3scQrGuJuRmoh62gE3QtAdFwZDYcYQtMCktuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiDxa87blQZhieelfzZcnY6oPu45ueVp9Y+NH6ZBdxkpV1EXakYpCvAbiK9IwqchA
         RpqSoUtbyflTfx/2G8sHFYKTguNZo+/C57Q7QrD6XXqSprL4HvC1p2SiZd/38SNJ+B
         Khm9kZMHJHep3m5NZKgalsMKfRp46VzJQDfg5SMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.18 016/102] powerpc/prom_init: Fix kernel config grep
Date:   Tue,  5 Jul 2022 13:57:42 +0200
Message-Id: <20220705115618.877803339@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>

commit 6886da5f49e6d86aad76807a93f3eef5e4f01b10 upstream.

When searching for config options, use the KCONFIG_CONFIG shell variable
so that builds using non-standard config locations work.

Fixes: 26deb04342e3 ("powerpc: prepare string/mem functions for KASAN")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220624011745.4060795-1-Liam.Howlett@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/prom_init_check.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/prom_init_check.sh
+++ b/arch/powerpc/kernel/prom_init_check.sh
@@ -13,7 +13,7 @@
 # If you really need to reference something from prom_init.o add
 # it to the list below:
 
-grep "^CONFIG_KASAN=y$" .config >/dev/null
+grep "^CONFIG_KASAN=y$" ${KCONFIG_CONFIG} >/dev/null
 if [ $? -eq 0 ]
 then
 	MEM_FUNCS="__memcpy __memset"


