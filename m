Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F2968E880
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 07:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBHGw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 01:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHGwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 01:52:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3057442E5;
        Tue,  7 Feb 2023 22:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55085614A9;
        Wed,  8 Feb 2023 06:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802ECC433EF;
        Wed,  8 Feb 2023 06:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675839143;
        bh=1P71LfU0+7FJhlIeYP8dlsmXxGhh3Acgaywm3d013ZY=;
        h=From:To:Cc:Subject:Date:From;
        b=RyDU3ix2lD9bR86sxLas/tTYmH28sDiYAj6aJu6q1z1coHn1ODc7pYp24nYo3EMex
         XAuMLx/oCkn3UOiv+LgZCzSXDYTBSKPgSNYvtYbg4rFoeHi5lEMvrey8kBp12VBh3B
         EOHEH+kYvp+Huh18W7A7c9XLb/Wzv/5TfoTMQTobJP1JXCZDKFyOP/F0Ib19L72Hpd
         5R7KWA//vxQsXCiKuq1b3vPigUT1JRH3wY2D9K0QlekGSHM0YOfFukMByEi+w8bElH
         hQH5RuQ6BPTSrzPm2Q/rtC+R7iaYhMYmrVzOWKC5R70Ht0E++MuEKCE8+n0Idt5aYE
         RtebwbDa60i3w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc:     Bill Wendling <morbo@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] randstruct: disable Clang 15 support
Date:   Tue,  7 Feb 2023 22:51:33 -0800
Message-Id: <20230208065133.220589-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The randstruct support released in Clang 15 is unsafe to use due to a
bug that can cause miscompilations: "-frandomize-layout-seed
inconsistently randomizes all-function-pointers structs"
(https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
on the Clang 16 release branch, so add a Clang version check.

Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/Kconfig.hardening | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 53baa95cb644f..0f295961e7736 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -281,6 +281,9 @@ endmenu
 
 config CC_HAS_RANDSTRUCT
 	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
+	# Randstruct was first added in Clang 15, but it isn't safe to use until
+	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
 
 choice
 	prompt "Randomize layout of sensitive kernel structures"

base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
-- 
2.39.1

