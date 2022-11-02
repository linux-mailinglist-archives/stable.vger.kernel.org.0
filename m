Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8179615807
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiKBCn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiKBCn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E95212D1D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E1F1617BF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5393C433C1;
        Wed,  2 Nov 2022 02:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357034;
        bh=H0yjo94VTcuS6WRxlU3BtlXV/zdK7sgGgWDY1JJsraE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZQg2V37MnBY4bKtTtLF/WWusstmBd4idgiWmV9RdNJMu+huw0NL57EkZDnjL0Lae
         QiFBl+EzV6DKVbOFy9/sEJEG9SRk1miVkqPKTccOvx3+nfjIrro4nILBBfSMjnBWy2
         HG1FAO5TQQusqFLiTOQB3lSS1287WVsMzAVCQ5+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.0 102/240] s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
Date:   Wed,  2 Nov 2022 03:31:17 +0100
Message-Id: <20221102022113.700254312@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit a262d3ad6a433e4080cecd0a8841104a5906355e upstream.

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entry.

Cc: <stable@vger.kernel.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/futex.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -17,7 +17,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\


