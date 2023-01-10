Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1025A6648BB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbjAJSOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbjAJSNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0930188DD4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF0E6184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CC6C433EF;
        Tue, 10 Jan 2023 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374338;
        bh=5aFHYIVxMfb6Kc0qnVsY3n++IxGDVygAskwKw6gclMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h723iLCsNCvp1hAJ/Rs58qvAkeExxgovP9LS6tuUICuCd8bPinL13ha8uQEh/43QT
         0Q54SU5Gs5ACLXodna10g2XNc1yQlAQfM2S6NQ34B/AHcw+0G6UyqBZFiTQZgW8k8J
         i60eJUaZv/NIdn7Q9TVelBmRH1Gbas+/EZTN1Xf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Dooks <ben-linux@fluff.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 134/148] riscv: uaccess: fix type of 0 variable on error in get_user()
Date:   Tue, 10 Jan 2023 19:03:58 +0100
Message-Id: <20230110180021.430080179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Ben Dooks <ben-linux@fluff.org>

commit b9b916aee6715cd7f3318af6dc360c4729417b94 upstream.

If the get_user(x, ptr) has x as a pointer, then the setting
of (x) = 0 is going to produce the following sparse warning,
so fix this by forcing the type of 'x' when access_ok() fails.

fs/aio.c:2073:21: warning: Using plain integer as NULL pointer

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20221229170545.718264-1-ben-linux@fluff.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -165,7 +165,7 @@ do {								\
 	might_fault();						\
 	access_ok(__p, sizeof(*__p)) ?		\
 		__get_user((x), __p) :				\
-		((x) = 0, -EFAULT);				\
+		((x) = (__force __typeof__(x))0, -EFAULT);	\
 })
 
 #define __put_user_asm(insn, x, ptr, err)			\


