Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A6528F05
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346163AbiEPTr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346528AbiEPTq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:46:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708FE3FD86;
        Mon, 16 May 2022 12:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DD9B815F6;
        Mon, 16 May 2022 19:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6277BC385AA;
        Mon, 16 May 2022 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730221;
        bh=Rg44HkJDgpVLxYjTCgMXa57aUQsSoFIyEN5tEb4DCzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHYMF7DmOKIoRVuY3CjLZaSqEgVpzrU9FIF0hAFEZGu9wb3CmFj4ldiGrfJc+13uA
         GJMKzwXrJTx7QFqnSLL+T8BkjvffC6/9Vrs6KiimFK9dTfvLkZYhmz4Uh3ttMJpaAX
         7PhjEnLxlX6JXU72TCOzdsfjPNpbe7uEcSTTbhPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Sudip Mukherjee" 
        <sudipm.mukherjee@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 39/43] MIPS: fix build with gcc-12
Date:   Mon, 16 May 2022 21:36:50 +0200
Message-Id: <20220516193615.874013453@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

Some mips builds with gcc-12 fails with the error:
arch/mips/jz4740/setup.c:64:25: error: comparison between two arrays
	[-Werror=array-compare]
   	64 |         if (__dtb_start != __dtb_end)

'd24f48767d5e ("MIPS: Use address-of operator on section symbols")' has
been applied which fixes most of the error, but it missed one file which
was not available upstream when the change was done.

Fixes: d24f48767d5e ("MIPS: Use address-of operator on section symbols")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/jz4740/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/jz4740/setup.c
+++ b/arch/mips/jz4740/setup.c
@@ -61,7 +61,7 @@ void __init plat_mem_setup(void)
 
 	jz4740_reset_init();
 
-	if (__dtb_start != __dtb_end)
+	if (&__dtb_start != &__dtb_end)
 		dtb = __dtb_start;
 	else
 		dtb = (void *)fw_passed_dtb;


