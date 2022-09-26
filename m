Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78FD5E9F6B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiIZKZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiIZKYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186914D24D;
        Mon, 26 Sep 2022 03:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8427F60BEF;
        Mon, 26 Sep 2022 10:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBEDC433C1;
        Mon, 26 Sep 2022 10:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187469;
        bh=wuZN+QtA4rf6Hs9xjlQ4uC96UOzN/ztHw+3mXvo/XEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufri+XmHZKkitq4GBDa6GcYrG33scQr3tNNwjLS95TSE872+Y9SeTTOao93vijS5S
         GV+JHU3ycUe9MQ6BJs+Vkb/KlmrbI1kPsMrvjcWCO90sXafsw0bTqJvzN5CC4ZcA/X
         n57juBrGGEdTSI6SKI3uxgrDiCaBcrKVTtBEVgb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Marth <daniel.marth@inso.tuwien.ac.at>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/58] efi: libstub: Disable struct randomization
Date:   Mon, 26 Sep 2022 12:11:25 +0200
Message-Id: <20220926100741.658952661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 1a3887924a7e6edd331be76da7bf4c1e8eab4b1e ]

The EFI stub is a wrapper around the core kernel that makes it look like
a EFI compatible PE/COFF application to the EFI firmware. EFI
applications run on top of the EFI runtime, which is heavily based on
so-called protocols, which are struct types consisting [mostly] of
function pointer members that are instantiated and recorded in a
protocol database.

These structs look like the ideal randomization candidates to the
randstruct plugin (as they only carry function pointers), but of course,
these protocols are contracts between the firmware that exposes them,
and the EFI applications (including our stubbed kernel) that invoke
them. This means that struct randomization for EFI protocols is not a
great idea, and given that the stub shares very little data with the
core kernel that is represented as a randomizable struct, we're better
off just disabling it completely here.

Cc: <stable@vger.kernel.org> # v4.14+
Reported-by: Daniel Marth <daniel.marth@inso.tuwien.ac.at>
Tested-by: Daniel Marth <daniel.marth@inso.tuwien.ac.at>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index e0cff3b942ac..7fad5d90898b 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -31,6 +31,13 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
+#
+# struct randomization only makes sense for Linux internal types, which the EFI
+# stub code never touches, so let's turn off struct randomization for the stub
+# altogether
+#
+KBUILD_CFLAGS := $(filter-out $(RANDSTRUCT_CFLAGS), $(KBUILD_CFLAGS))
+
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 
-- 
2.35.1



