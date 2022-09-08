Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F815B2419
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIHRA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIHRAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C349A032E
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 440E9B818B5
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 17:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44014C433D6;
        Thu,  8 Sep 2022 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662656420;
        bh=DcpemsTi8CGsNoSngjCqd7bSiW2moKMxh1WsBZhKkBE=;
        h=Subject:To:Cc:From:Date:From;
        b=lhtY8/r8h7eCArxv5OLdaukg2zhxft3U2bEOaFVv0UTskeXBDZaLB4XnSquy4tquy
         Rz965fzTRFW0XphV40x3dqNj2ldxnOibG4nCa007yThUZDfknv7K/YgneGEnOeQDWa
         +l3od2OFJCvVwfEPCuvYak7vkMemfczITjG934SY=
Subject: FAILED: patch "[PATCH] efi: libstub: Disable struct randomization" failed to apply to 4.19-stable tree
To:     ardb@kernel.org, daniel.marth@inso.tuwien.ac.at,
        keescook@chromium.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Sep 2022 19:00:31 +0200
Message-ID: <1662656431138159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1a3887924a7e ("efi: libstub: Disable struct randomization")
cc49c71d2abe ("efi/libstub: Disable Shadow Call Stack")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1a3887924a7e6edd331be76da7bf4c1e8eab4b1e Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 22 Aug 2022 19:20:33 +0200
Subject: [PATCH] efi: libstub: Disable struct randomization

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

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d0537573501e..2c67f71f2375 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -37,6 +37,13 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
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
 # disable LTO

