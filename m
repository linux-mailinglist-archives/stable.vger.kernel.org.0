Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73601615808
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiKBCoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiKBCoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:44:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6601513F09
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03263617C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE12C433D6;
        Wed,  2 Nov 2022 02:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357040;
        bh=xGPy3ab1kZFncV3U6Iw5Ue/QqkxXIb11oUJCZNdamKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrPbxz7VV0sGabJwIWUS9D+5EyyAq6eCf9RZrfrBPmWOF+b/bsBF2qIX+0GLNwUBD
         kgFnenexzz52p73Td6JhxhUpkSQhY5dmddmWYCUgyBFtfJ6XGBuj6gnLlLEK9//0U0
         VYTQ2uT+jniXVyHTrwS67t0gTkaNzMqGUbsZ3NoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.0 103/240] s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()
Date:   Wed,  2 Nov 2022 03:31:18 +0100
Message-Id: <20221102022113.722629043@linuxfoundation.org>
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

commit 6ec803025cf3173a57222e4411097166bd06fa98 upstream.

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entry.

Cc: <stable@vger.kernel.org>
Fixes: f058599e22d5 ("s390/pci: Fix s390_mmio_read/write with MIO")
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -64,7 +64,7 @@ static inline int __pcistg_mio_inuser(
 	asm volatile (
 		"       sacf    256\n"
 		"0:     llgc    %[tmp],0(%[src])\n"
-		"       sllg    %[val],%[val],8\n"
+		"4:	sllg	%[val],%[val],8\n"
 		"       aghi    %[src],1\n"
 		"       ogr     %[val],%[tmp]\n"
 		"       brctg   %[cnt],0b\n"
@@ -72,7 +72,7 @@ static inline int __pcistg_mio_inuser(
 		"2:     ipm     %[cc]\n"
 		"       srl     %[cc],28\n"
 		"3:     sacf    768\n"
-		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
+		EX_TABLE(0b, 3b) EX_TABLE(4b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
 		:
 		[src] "+a" (src), [cnt] "+d" (cnt),
 		[val] "+d" (val), [tmp] "=d" (tmp),
@@ -215,10 +215,10 @@ static inline int __pcilg_mio_inuser(
 		"2:     ahi     %[shift],-8\n"
 		"       srlg    %[tmp],%[val],0(%[shift])\n"
 		"3:     stc     %[tmp],0(%[dst])\n"
-		"       aghi    %[dst],1\n"
+		"5:	aghi	%[dst],1\n"
 		"       brctg   %[cnt],2b\n"
 		"4:     sacf    768\n"
-		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b)
+		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b) EX_TABLE(5b, 4b)
 		:
 		[ioaddr_len] "+&d" (ioaddr_len.pair),
 		[cc] "+d" (cc), [val] "=d" (val),


