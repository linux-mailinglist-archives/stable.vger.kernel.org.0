Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15954987F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355572AbiFMLke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355713AbiFMLje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646072CC98;
        Mon, 13 Jun 2022 03:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED7E3B80E8D;
        Mon, 13 Jun 2022 10:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B8AC3411E;
        Mon, 13 Jun 2022 10:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117385;
        bh=o5pO4LCMS5/b+2fU+WThBdm9r/1xafoD8Nszr9ODGqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaYbDVZpeqrENWPyW7jtFIUczHbbBj/xCfQR4qPEotQ6BdFBgIL4IFvg+UNW9IiAa
         PeFiVEimtczMwwiOhC1TsVaPznPbuZ5fU+yEnATHQpgzEvcH4ytAXi2jt8yISD1KhF
         tDO2DB/LuePyrfBQTRiLWn9eicuIKK8zmxba+Cu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/287] s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES
Date:   Mon, 13 Jun 2022 12:07:35 +0200
Message-Id: <20220613094924.807804000@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 63678eecec57fc51b778be3da35a397931287170 ]

gcc 12 does not (always) optimize away code that should only be generated
if parameters are constant and within in a certain range. This depends on
various obscure kernel config options, however in particular
PROFILE_ALL_BRANCHES can trigger this compile error:

In function ‘__atomic_add_const’,
    inlined from ‘__preempt_count_add.part.0’ at ./arch/s390/include/asm/preempt.h:50:3:
./arch/s390/include/asm/atomic_ops.h:80:9: error: impossible constraint in ‘asm’
   80 |         asm volatile(                                                   \
      |         ^~~

Workaround this by simply disabling the optimization for
PROFILE_ALL_BRANCHES, since the kernel will be so slow, that this
optimization won't matter at all.

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/preempt.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/preempt.h b/arch/s390/include/asm/preempt.h
index 23a14d187fb1..1aebf09fbcd8 100644
--- a/arch/s390/include/asm/preempt.h
+++ b/arch/s390/include/asm/preempt.h
@@ -50,10 +50,17 @@ static inline bool test_preempt_need_resched(void)
 
 static inline void __preempt_count_add(int val)
 {
-	if (__builtin_constant_p(val) && (val >= -128) && (val <= 127))
-		__atomic_add_const(val, &S390_lowcore.preempt_count);
-	else
-		__atomic_add(val, &S390_lowcore.preempt_count);
+	/*
+	 * With some obscure config options and CONFIG_PROFILE_ALL_BRANCHES
+	 * enabled, gcc 12 fails to handle __builtin_constant_p().
+	 */
+	if (!IS_ENABLED(CONFIG_PROFILE_ALL_BRANCHES)) {
+		if (__builtin_constant_p(val) && (val >= -128) && (val <= 127)) {
+			__atomic_add_const(val, &S390_lowcore.preempt_count);
+			return;
+		}
+	}
+	__atomic_add(val, &S390_lowcore.preempt_count);
 }
 
 static inline void __preempt_count_sub(int val)
-- 
2.35.1



