Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0732667687
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbjALOc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbjALOcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:32:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F38F544F7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5569CE1E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BCFC433F2;
        Thu, 12 Jan 2023 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533426;
        bh=fErM/nS5AKdkuMKYzcjCzX7TJtUGZ6MN7lqqrlTbzco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTCqgyXki6Mkzm6p44q7ZQ5NIz0dZuqybDmB/2TRkVnKu665Mg/anC2gM6xVO42Ik
         YD4QudNmdAvUfhbsgWxk0iWpy2NuJU3Wld850YpTjxbQmNZ7R79dBFEov5uxmCRvmT
         uvpHPi5Vko8jigHXZpdpAJFau2Wq4T2HtdHgrlIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/783] powerpc/xmon: Enable breakpoints on 8xx
Date:   Thu, 12 Jan 2023 14:52:30 +0100
Message-Id: <20230112135544.427000750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 30662217885d7341161924acf1665924d7d37d64 ]

Since commit 4ad8622dc548 ("powerpc/8xx: Implement hw_breakpoint"),
8xx has breakpoints so there is no reason to opt breakpoint logic
out of xmon for the 8xx.

Fixes: 4ad8622dc548 ("powerpc/8xx: Implement hw_breakpoint")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b0607f1113d1558e73476bb06db0ee16d31a6e5b.1608716197.git.christophe.leroy@csgroup.eu
Stable-dep-of: 1c4a4a4c8410 ("powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 5559edf36756..c6a36b4045e8 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1383,7 +1383,6 @@ static long check_bp_loc(unsigned long addr)
 	return 1;
 }
 
-#ifndef CONFIG_PPC_8xx
 static int find_free_data_bpt(void)
 {
 	int i;
@@ -1395,7 +1394,6 @@ static int find_free_data_bpt(void)
 	printf("Couldn't find free breakpoint register\n");
 	return -1;
 }
-#endif
 
 static void print_data_bpts(void)
 {
@@ -1435,7 +1433,6 @@ bpt_cmds(void)
 	cmd = inchar();
 
 	switch (cmd) {
-#ifndef CONFIG_PPC_8xx
 	static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
 	int mode;
 	case 'd':	/* bd - hardware data breakpoint */
@@ -1497,7 +1494,6 @@ bpt_cmds(void)
 			force_enable_xmon();
 		}
 		break;
-#endif
 
 	case 'c':
 		if (!scanhex(&a)) {
-- 
2.35.1



