Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072E04F3251
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbiDEIhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238902AbiDEIT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20AA75224;
        Tue,  5 Apr 2022 01:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 509F4B81A37;
        Tue,  5 Apr 2022 08:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D33C385A0;
        Tue,  5 Apr 2022 08:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146180;
        bh=L6R+J0LD9oqPr/GMoUdF+rh68PuAhKpNLIeYgwFQZmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtmyJ0hD+FaLnZwMMBiNdgtoUrCBn0jaIxPg4JuuSst7+PGnrDAzjSt6dAkuUHzAI
         AvGphtbRP0SVMp6hZOoLclYOBo2awyhh1A2zGf2GZeuKSdWP/TGuGzFEe48tRe3TtE
         QYf9Z4wEhLV89P6UrO8i6JC18O+zTMXir1myPAa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>
Subject: [PATCH 5.17 0669/1126] powerpc/xive: fix return value of __setup handler
Date:   Tue,  5 Apr 2022 09:23:36 +0200
Message-Id: <20220405070427.262809860@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d64e3eab75a8e1e900c0fda2410a2df8893d8f85 ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.

A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings.

Also, error return codes don't mean anything to obsolete_checksetup() --
only non-zero (usually 1) or zero. So return 1 from xive_off() and
xive_store_eoi_cmdline().

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE interrupt controller")
Fixes: c21ee04f11ae ("powerpc/xive: Add a kernel parameter for StoreEOI")
[lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru]
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>:
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220313065936.4363-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 1ca5564bda9d..89c86f32aff8 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1708,20 +1708,20 @@ __be32 *xive_queue_page_alloc(unsigned int cpu, u32 queue_shift)
 static int __init xive_off(char *arg)
 {
 	xive_cmdline_disabled = true;
-	return 0;
+	return 1;
 }
 __setup("xive=off", xive_off);
 
 static int __init xive_store_eoi_cmdline(char *arg)
 {
 	if (!arg)
-		return -EINVAL;
+		return 1;
 
 	if (strncmp(arg, "off", 3) == 0) {
 		pr_info("StoreEOI disabled on kernel command line\n");
 		xive_store_eoi = false;
 	}
-	return 0;
+	return 1;
 }
 __setup("xive.store-eoi=", xive_store_eoi_cmdline);
 
-- 
2.34.1



