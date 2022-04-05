Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DC74F27C1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiDEIIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiDEH7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDFF62FC;
        Tue,  5 Apr 2022 00:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FB1FB81B18;
        Tue,  5 Apr 2022 07:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD2CC340EE;
        Tue,  5 Apr 2022 07:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145377;
        bh=7PbildU4fVy2AP3yvxFY7nRP8gtRqmn3F61F8jyqIRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RI61EiJOzstULrfOI4ImFfUeeCWaxsnz2VlDo15tv7jsEmRyPLZP3TgJITIryULb
         uIZByVhLzsSwDf66cKQM94AyLSGHZZfD0c42h8yg5IkQReOrYloQIEiBAUxdd+GOpf
         HWgm9gqWT8zbsQW8jzSz82r1usgj4XVl/UIVinVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0345/1126] ARM: ftrace: ensure that ADR takes the Thumb bit into account
Date:   Tue,  5 Apr 2022 09:18:12 +0200
Message-Id: <20220405070417.742191764@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit dd88b03ff0c84f4bcbe1419b93a4bed429fed3be ]

Using ADR to take the address of 'ftrace_stub' via a local label
produces an address that has the Thumb bit cleared, which means the
subsequent comparison is guaranteed to fail. Instead, use the badr
macro, which forces the Thumb bit to be set.

Fixes: a3ba87a61499 ("ARM: 6316/1: ftrace: add Thumb-2 support")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-ftrace.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/entry-ftrace.S b/arch/arm/kernel/entry-ftrace.S
index a74289ebc803..f4886fb6e9ba 100644
--- a/arch/arm/kernel/entry-ftrace.S
+++ b/arch/arm/kernel/entry-ftrace.S
@@ -40,7 +40,7 @@
 	mcount_enter
 	ldr	r0, =ftrace_trace_function
 	ldr	r2, [r0]
-	adr	r0, .Lftrace_stub
+	badr	r0, .Lftrace_stub
 	cmp	r0, r2
 	bne	1f
 
-- 
2.34.1



