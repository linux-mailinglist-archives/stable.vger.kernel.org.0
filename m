Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899BE55861B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiFWSIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbiFWSGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CC989D33;
        Thu, 23 Jun 2022 10:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18212B824C2;
        Thu, 23 Jun 2022 17:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68583C385A2;
        Thu, 23 Jun 2022 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004741;
        bh=NEJRdzIBCon7lIGhM4SzG1yXI0kNFTJSk5arjusZ2Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv8ySDuuZpRyTUgalgeg0SB+qKeR0HzK756WN3wP5086Lgxqk99e/KV+RSshOwAw+
         ZwOJ1HhrRIhLJ5ED4Jai7snrpPy2Nzeq80OOQtWpVBmDeAR4C6TpWzTLblZf+IR5lj
         bXdkzFC6WdG2C4HK3z3rD+d70udM077JXjeE0h7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 136/234] s390: define get_cycles macro for arch-override
Date:   Thu, 23 Jun 2022 18:43:23 +0200
Message-Id: <20220623164346.905616392@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 2e3df523256cb9836de8441e9c791a796759bb3c upstream.

S390x defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/timex.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -177,6 +177,7 @@ static inline cycles_t get_cycles(void)
 {
 	return (cycles_t) get_tod_clock() >> 2;
 }
+#define get_cycles get_cycles
 
 int get_phys_clock(unsigned long *clock);
 void init_cpu_timer(void);


