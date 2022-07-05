Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18766566BCB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiGEMJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbiGEMIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E1015FFB;
        Tue,  5 Jul 2022 05:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB98B817DB;
        Tue,  5 Jul 2022 12:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87C8C341C7;
        Tue,  5 Jul 2022 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022852;
        bh=pUFp6/3scQrGuJuRmoh62gE3QtAdFwZDYcYQtMCktuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfhtBMF+bZhxxYRftojrtKOGizaJzlxGJBb6hMnPILDQhK3y/AA3Mjslq1TqL/6hd
         QodAbLwIJfy/dFP4pTPANVkg4mv8Hnxm0gteo3aIeOI02KEPhk7e6oC/CdsAatnt1G
         f0yZP1s+wU64tuNHU5r1Bch07Ftx3TkzJjJ3NWQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 05/84] powerpc/prom_init: Fix kernel config grep
Date:   Tue,  5 Jul 2022 13:57:28 +0200
Message-Id: <20220705115615.483122211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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


