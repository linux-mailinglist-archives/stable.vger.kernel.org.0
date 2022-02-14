Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF5A4B49DE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiBNKby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347455AbiBNKb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FF19FAEF;
        Mon, 14 Feb 2022 02:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F07A60A69;
        Mon, 14 Feb 2022 09:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A2FC340EF;
        Mon, 14 Feb 2022 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832794;
        bh=LTboYfmH/a68TcCCBAK+TJjoXyW6Y/B18xEZL5Dz6d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKNkSu8q6Vc4cZOlgVGmMh2iI99XLrdeVQkP1s2fVTwyVQzb+5LgJ8Wzt9Alx6d1o
         Ug++DRAyLuaj0NVHe58xkB6AtzpzHowqTEcpCyCkl3DAqAYamUcJznWX98I5zQg6Io
         UMmmeOaG58WkPVhCoZ2DezmqNTHBSTrOuWcldCYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 126/203] s390/module: fix building test_modules_helpers.o with clang
Date:   Mon, 14 Feb 2022 10:26:10 +0100
Message-Id: <20220214092514.524819302@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit e286f231eab410793f3e91c924e6dbd23edee05a ]

Move test_modules_return_* prototypes into a header file in order to
placate -Wmissing-prototypes.

Fixes: 90c5318795ee ("s390/module: test loading modules with a lot of relocations")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/test_modules.c | 3 ---
 arch/s390/lib/test_modules.h | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/lib/test_modules.c b/arch/s390/lib/test_modules.c
index d056baa8fbb0c..9894009fc1f25 100644
--- a/arch/s390/lib/test_modules.c
+++ b/arch/s390/lib/test_modules.c
@@ -5,9 +5,6 @@
 
 #include "test_modules.h"
 
-#define DECLARE_RETURN(i) int test_modules_return_ ## i(void)
-REPEAT_10000(DECLARE_RETURN);
-
 /*
  * Test that modules with many relocations are loaded properly.
  */
diff --git a/arch/s390/lib/test_modules.h b/arch/s390/lib/test_modules.h
index 43b5e4b4af3e4..6371fcf176845 100644
--- a/arch/s390/lib/test_modules.h
+++ b/arch/s390/lib/test_modules.h
@@ -47,4 +47,7 @@
 	__REPEAT_10000_1(f, 8); \
 	__REPEAT_10000_1(f, 9)
 
+#define DECLARE_RETURN(i) int test_modules_return_ ## i(void)
+REPEAT_10000(DECLARE_RETURN);
+
 #endif
-- 
2.34.1



