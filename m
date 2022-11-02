Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC525615806
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiKBCnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKBCnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:43:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F12812D3C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2D46617C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935CAC433C1;
        Wed,  2 Nov 2022 02:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357028;
        bh=JQ3hlUEBrW4yUE03XPE7uh+UFJwFsBD4xNo0EOC8UwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrqVpHThfi0C33S72Sh0dDWGprw/X5DMTWmzIvcLP9CgI7jdGg7Zgm1AEy9YNkWnu
         Xb1jIGFKXCC3WhPa2yviqNGifNcQQMEBnykcHvSF+O6vOBHFsNEdjlBWfXH7wly0ru
         1RwaCkHXk0h08ItQZt7xySC5YiBTskS4Srcopmfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.0 101/240] s390/uaccess: add missing EX_TABLE entries to __clear_user()
Date:   Wed,  2 Nov 2022 03:31:16 +0100
Message-Id: <20221102022113.677842607@linuxfoundation.org>
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

commit 4e1b5a86a5edfbefc9396d41b0fc1a2ebd0101b6 upstream.

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entries.

Cc: <stable@vger.kernel.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/uaccess.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -156,7 +156,7 @@ unsigned long __clear_user(void __user *
 	asm volatile(
 		"   lr	  0,%[spec]\n"
 		"0: mvcos 0(%1),0(%4),%0\n"
-		"   jz	  4f\n"
+		"6: jz	  4f\n"
 		"1: algr  %0,%2\n"
 		"   slgr  %1,%2\n"
 		"   j	  0b\n"
@@ -166,11 +166,11 @@ unsigned long __clear_user(void __user *
 		"   clgr  %0,%3\n"	/* copy crosses next page boundary? */
 		"   jnh	  5f\n"
 		"3: mvcos 0(%1),0(%4),%3\n"
-		"   slgr  %0,%3\n"
+		"7: slgr  %0,%3\n"
 		"   j	  5f\n"
 		"4: slgr  %0,%0\n"
 		"5:\n"
-		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
+		EX_TABLE(0b,2b) EX_TABLE(6b,2b) EX_TABLE(3b,5b) EX_TABLE(7b,5b)
 		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
 		: "a" (empty_zero_page), [spec] "d" (spec.val)
 		: "cc", "memory", "0");


