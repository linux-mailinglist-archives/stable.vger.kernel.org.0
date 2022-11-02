Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A61615AD1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiKBDmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKBDl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:41:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEAF26ADD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D966E61729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357DC433D7;
        Wed,  2 Nov 2022 03:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360501;
        bh=6X4F1ImfmZP+i5s0+q25rL0TVqnHIkZJW2U9rHt5HtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzOKoWXgGjihcVL2bhfpF8vHKQg2TJVwbSWz6Qq6eCWIYVAISOHiUGZQu39VnKBGf
         F5bcX2fe6xD33UmDelD72w6wPABNREidsc0+o+Qu6BBGgbptxqU0LZTjopTEmN6lTb
         v9jb/eSmPpzM/W2YEvZksVKGy9/aSyUB0BEpQYYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.14 31/60] s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
Date:   Wed,  2 Nov 2022 03:34:52 +0100
Message-Id: <20221102022052.095616723@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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
@@ -16,7 +16,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\


