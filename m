Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C163586C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiKWJ5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiKWJ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:56:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D8111C19
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60400619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4ABC433D7;
        Wed, 23 Nov 2022 09:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197076;
        bh=Dxw+JxFyB9dso11235OTLMOl7ze509DMwUFuMvzxTw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iL4rorxuYZI/En9auCMV8zjXYgHPCjfQ5D7ou3epHbLHJKKxTPcedhBEpn930yvY3
         KX5By+2ShUQ+e+27Uk5+6jPU1Olbq62mdiEsLUtbigdm9/TJ10MgJ2eemn00HrNueT
         TIdk26eOceqgeu8I9XB7lK2Ad3roDpUH3Uk0Vu0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 191/314] s390: avoid using global register for current_stack_pointer
Date:   Wed, 23 Nov 2022 09:50:36 +0100
Message-Id: <20221123084634.212088267@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit e3c11025bcd2142a61abe5806b2f86a0e78118df ]

Commit 30de14b1884b ("s390: current_stack_pointer shouldn't be a
function") made current_stack_pointer a global register variable like
on many other architectures. Unfortunately on s390 it uncovers old
gcc bug which is fixed only since gcc-9.1 [gcc commit 3ad7fed1cc87
("S/390: Fix PR89775. Stackpointer save/restore instructions removed")]
and backported to gcc-8.4 and later. Due to this bug gcc versions prior
to 8.4 generate broken code which leads to stack corruptions.

Current minimal gcc version required to build the kernel is declared
as 5.1. It is not possible to fix all old gcc versions, so work
around this problem by avoiding using global register variable for
current_stack_pointer.

Fixes: 30de14b1884b ("s390: current_stack_pointer shouldn't be a function")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index bd66f8e34949..00f45d8f1efa 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -202,7 +202,16 @@ unsigned long __get_wchan(struct task_struct *p);
 /* Has task runtime instrumentation enabled ? */
 #define is_ri_task(tsk) (!!(tsk)->thread.ri_cb)
 
-register unsigned long current_stack_pointer asm("r15");
+/* avoid using global register due to gcc bug in versions < 8.4 */
+#define current_stack_pointer (__current_stack_pointer())
+
+static __always_inline unsigned long __current_stack_pointer(void)
+{
+	unsigned long sp;
+
+	asm volatile("lgr %0,15" : "=d" (sp));
+	return sp;
+}
 
 static __always_inline unsigned short stap(void)
 {
-- 
2.35.1



