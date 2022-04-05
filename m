Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20204F3622
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiDEK66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347021AbiDEJpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94861DCAB2;
        Tue,  5 Apr 2022 02:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18A6B61368;
        Tue,  5 Apr 2022 09:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6EEC385A2;
        Tue,  5 Apr 2022 09:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151134;
        bh=Znaktkp0TlhhTmv22siN8VXYQMsR80xwUmAM0j+apdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q18bL4XuhWxLox5jJOsAy1UahBegivjT/t0MG+fx8vpq4Jjkh1ClI5B/RJDgz+feO
         cLt6LVo8NOZBk5RbyJvM28IiSS7k8Qhi09rMzBIHh1x2FlcqLeuubnJwJOYHfrd5sI
         h49EDUalbGbLRGKr3VJzxcxfCdSC0ssEV9Rce3Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/913] video: fbdev: controlfb: Fix COMPILE_TEST build
Date:   Tue,  5 Apr 2022 09:22:31 +0200
Message-Id: <20220405070348.520689482@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 567e44fb51b4f909ae58038a7301352eecea8426 ]

If PPC_BOOK3S, PPC_PMAC and PPC32 is n, COMPILE_TEST build fails:

drivers/video/fbdev/controlfb.c:70:0: error: "pgprot_cached_wthru" redefined [-Werror]
 #define pgprot_cached_wthru(prot) (prot)

In file included from ./arch/powerpc/include/asm/pgtable.h:20:0,
                 from ./include/linux/pgtable.h:6,
                 from ./include/linux/mm.h:33,
                 from drivers/video/fbdev/controlfb.c:37:
./arch/powerpc/include/asm/nohash/pgtable.h:243:0: note: this is the location of the previous definition
 #define pgprot_cached_wthru(prot) (__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_CTL) | \

Fixes: a07a63b0e24d ("video: fbdev: controlfb: add COMPILE_TEST support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/controlfb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index 509311471d51..bd59e7b11ed5 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -67,7 +67,9 @@
 #define out_8(addr, val)	(void)(val)
 #define in_le32(addr)		0
 #define out_le32(addr, val)	(void)(val)
+#ifndef pgprot_cached_wthru
 #define pgprot_cached_wthru(prot) (prot)
+#endif
 #else
 static void invalid_vram_cache(void __force *addr)
 {
-- 
2.34.1



