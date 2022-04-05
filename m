Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21E94F25DD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiDEHxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbiDEHwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E97A99EF8;
        Tue,  5 Apr 2022 00:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB9E61714;
        Tue,  5 Apr 2022 07:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E223C3410F;
        Tue,  5 Apr 2022 07:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144891;
        bh=7wCX3eOKIpkxHj64CzX6+7Q6t9WICOqWbk2IYw7KeWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGo/3apMjiixvcKpEDBw1wZ4wZawrrMUPqKgpMnMvP2il6FCT2+YgaERkhnHlflL1
         SIGLmR2AR+K3sf63M8rSxJX3BPRMcwDe946UsQsu6Olexq2qFA6lXkpLps4FEKoZf6
         vh+nCt/hQs+cdI+ZA2fVnwNtLCtPUOxYWmhSiv6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.17 0181/1126] xtensa: fix xtensa_wsr always writing 0
Date:   Tue,  5 Apr 2022 09:15:28 +0200
Message-Id: <20220405070412.918334146@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit a3d0245c58f962ee99d4440ea0eaf45fb7f5a5cc upstream.

The commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
replaced 'WSR' macro in the function xtensa_wsr with 'xtensa_set_sr',
but variable 'v' in the xtensa_set_sr body shadowed the argument 'v'
passed to it, resulting in wrong value written to debug registers.

Fix that by removing intermediate variable from the xtensa_set_sr
macro body.

Cc: stable@vger.kernel.org
Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/processor.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -246,8 +246,8 @@ extern unsigned long __get_wchan(struct
 
 #define xtensa_set_sr(x, sr) \
 	({ \
-	 unsigned int v = (unsigned int)(x); \
-	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: "a"(v)); \
+	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: \
+			       "a"((unsigned int)(x))); \
 	 })
 
 #define xtensa_get_sr(sr) \


