Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458815EA096
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiIZKkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiIZKhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:37:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C1A52E42;
        Mon, 26 Sep 2022 03:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D660DB80924;
        Mon, 26 Sep 2022 10:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C942C433C1;
        Mon, 26 Sep 2022 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187724;
        bh=GBX0JFX1Jnc9kGAMgl+8H64Kis2TflBUuMzRAFsOVlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5Fi+c3kxdO6hZCzz0IWxn3EXi0+U7ISpZNGucYFq7kPhy2CEcEX+Apw3/yXg8aAz
         to65S7I3i+A9tvWtn3N/gv0yxIq/iSDQxIYgb9hoig+M66NORmcJnA0k2W5RTuK6Y8
         6VSDCAQDvb/Di/X6vxdMVcIlRbKJ5mQV3d/KSFeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Marth <daniel.marth@inso.tuwien.ac.at>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/120] efi: libstub: Disable struct randomization
Date:   Mon, 26 Sep 2022 12:10:41 +0200
Message-Id: <20220926100750.874865087@linuxfoundation.org>
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
index f3540d5dd276..34e4b31010bd 100644
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



