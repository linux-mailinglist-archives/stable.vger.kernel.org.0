Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118465E9F45
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiIZKWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiIZKVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C1A4BA68;
        Mon, 26 Sep 2022 03:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37EE60B7E;
        Mon, 26 Sep 2022 10:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF965C433C1;
        Mon, 26 Sep 2022 10:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187370;
        bh=y7+eLYjbcVCNH/jVgiBmW+NgV5JOjwNfZtMYz35Va1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwt5x/nZTzaMcy1Sa50UAUnFUcDz8k5JKd1rUKli+J/xsZur1wPS0ZNjdF803RaBO
         TrwSr7lTntMH05aVOEwuh2kmawRBtV4MgXfFbdFdmJDucYJNIOPx2eey+Fp2VhE/lb
         Dk7MjAXN2/1yH2sjY4azrwRVjLYcnMTbV5Bby4t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/40] efi/libstub: Disable Shadow Call Stack
Date:   Mon, 26 Sep 2022 12:11:33 +0200
Message-Id: <20220926100738.422260948@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit cc49c71d2abe99c1c2c9bedf0693ad2d3ee4a067 ]

Shadow stacks are not available in the EFI stub, filter out SCS flags.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 1a3887924a7e ("efi: libstub: Disable struct randomization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 678bc910e080..54dbcec7e06f 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -23,6 +23,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-ffreestanding) \
 				   $(call cc-option,-fno-stack-protector)
 
+# remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.35.1



