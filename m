Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7DC4F3C3C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiDEMGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358258AbiDEK2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7C3DE92;
        Tue,  5 Apr 2022 03:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E4146176C;
        Tue,  5 Apr 2022 10:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996AFC385A1;
        Tue,  5 Apr 2022 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153853;
        bh=u9rCPfReMu1CF3XAbSDPGJv4mLkXhlcRuj4PzOdlpg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa79Birc6F8XGlSTUc+g+shWlZ42vPzjfTI9MyFJ5q6kvAHZd6oC82VRD1jtQ3WHk
         igaXBYWaycYbXH9MQ7jxKU+MKA658ib/004J4uAmNkkrEB7YHJjxmj+GPpfu2lhnKb
         73R7eeZTpOH+VAufRJcDxOJIhn4QroSj+zTzRvtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/599] powerpc/Makefile: Dont pass -mcpu=powerpc64 when building 32-bit
Date:   Tue,  5 Apr 2022 09:30:26 +0200
Message-Id: <20220405070308.712573783@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2863dd2db23e0407f6c50b8ba5c0e55abef894f1 ]

When CONFIG_GENERIC_CPU=y (true for all our defconfigs) we pass
-mcpu=powerpc64 to the compiler, even when we're building a 32-bit
kernel.

This happens because we have an ifdef CONFIG_PPC_BOOK3S_64/else block in
the Makefile that was written before 32-bit supported GENERIC_CPU. Prior
to that the else block only applied to 64-bit Book3E.

The GCC man page says -mcpu=powerpc64 "[specifies] a pure ... 64-bit big
endian PowerPC ... architecture machine [type], with an appropriate,
generic processor model assumed for scheduling purposes."

It's unclear how that interacts with -m32, which we are also passing,
although obviously -m32 is taking precedence in some sense, as the
32-bit kernel only contains 32-bit instructions.

This was noticed by inspection, not via any bug reports, but it does
affect code generation. Comparing before/after code generation, there
are some changes to instruction scheduling, and the after case (with
-mcpu=powerpc64 removed) the compiler seems more keen to use r8.

Fix it by making the else case only apply to Book3E 64, which excludes
32-bit.

Fixes: 0e00a8c9fd92 ("powerpc: Allow CPU selection also on PPC32")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220215112858.304779-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 5c8c06215dd4..7a96cdefbd4e 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -172,7 +172,7 @@ else
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power7,$(call cc-option,-mtune=power5))
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mcpu=power5,-mcpu=power4)
 endif
-else
+else ifdef CONFIG_PPC_BOOK3E_64
 CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
 endif
 
-- 
2.34.1



