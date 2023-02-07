Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2F768D7C3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjBGNDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjBGNDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AF965A4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009A7B81990
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE30C433D2;
        Tue,  7 Feb 2023 13:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774962;
        bh=DSaHHhfg6Nd4z26UvEqjPFxU8m5ALTdO4oNPssNSTLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6pbMXZDJwFza03NpPci8gD4oAchX8MmsA3u3VMXbY0Uols5uWAFrFm0bhkijohnv
         tFlzmn1m8+NwkHvrycOK8UHjGqWMjnkn9mFCZ/PFPlmwN7HjexJJeAlXL0uGia5Px/
         /r0t4q4qxdJi0dMETOictOOZVcd3b2dABjhPIz3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Luebbe <jlu@pengutronix.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/208] kbuild: modinst: Fix build error when CONFIG_MODULE_SIG_KEY is a PKCS#11 URI
Date:   Tue,  7 Feb 2023 13:55:46 +0100
Message-Id: <20230207125638.527611246@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Jan Luebbe <jlu@pengutronix.de>

[ Upstream commit 22e46f6480e83bcf49b6d5e6b66c81872c97a902 ]

When CONFIG_MODULE_SIG_KEY is PKCS#11 URI (pkcs11:*), signing of modules
fails:

  scripts/sign-file sha256 /.../linux/pkcs11:token=foo;object=bar;pin-value=1111 certs/signing_key.x509 /.../kernel/crypto/tcrypt.ko
  Usage: scripts/sign-file [-dp] <hash algo> <key> <x509> <module> [<dest>]
         scripts/sign-file -s <raw sig> <hash algo> <x509> <module> [<dest>]

First, we need to avoid adding the $(srctree)/ prefix to the URL.

Second, since the kconfig string values no longer include quotes, we need to add
them again when passing a PKCS#11 URI to sign-file. This avoids
splitting by the shell if the URI contains semicolons.

Fixes: 4db9c2e3d055 ("kbuild: stop using config_filename in scripts/Makefile.modsign")
Fixes: 129ab0d2d9f3 ("kbuild: do not quote string values in include/config/auto.conf")
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modinst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index a4c987c23750..10df89b9ef67 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -66,9 +66,13 @@ endif
 # Don't stop modules_install even if we can't sign external modules.
 #
 ifeq ($(CONFIG_MODULE_SIG_ALL),y)
+ifeq ($(filter pkcs11:%, $(CONFIG_MODULE_SIG_KEY)),)
 sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(srctree)/)$(CONFIG_MODULE_SIG_KEY)
+else
+sig-key := $(CONFIG_MODULE_SIG_KEY)
+endif
 quiet_cmd_sign = SIGN    $@
-      cmd_sign = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(sig-key) certs/signing_key.x509 $@ \
+      cmd_sign = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) "$(sig-key)" certs/signing_key.x509 $@ \
                  $(if $(KBUILD_EXTMOD),|| true)
 else
 quiet_cmd_sign :=
-- 
2.39.0



