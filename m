Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539E25EA080
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiIZKjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiIZKh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:37:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE22A52DF5;
        Mon, 26 Sep 2022 03:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3073B80835;
        Mon, 26 Sep 2022 10:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D4C433D7;
        Mon, 26 Sep 2022 10:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187721;
        bh=jqnPyBN37PEz0xr+ig2bvxymuiERr5uZNWmJUI6FYcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeAyUvu8fSoL+ci5wULiUwzUDd2BXwmnZRC9mPlIIYZOo/gBAfJtrYdtPsIksWGND
         niDdPLt9ctO1t9uU2MspMg7S6G3zQ6sM/+MEAjJQisWzHBACuN4Zd2ahUI4h+2ZUSz
         FtMjdKux5HCtYIpclAf1VartvHPFIDoPM8AGUxAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/120] efi/libstub: Disable Shadow Call Stack
Date:   Mon, 26 Sep 2022 12:10:40 +0200
Message-Id: <20220926100750.834421805@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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
index 8c5b5529dbc0..f3540d5dd276 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -31,6 +31,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
+# remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.35.1



