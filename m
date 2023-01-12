Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B00766767B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbjALOcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbjALObf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:31:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE75FB93
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE5A60A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF67C433EF;
        Thu, 12 Jan 2023 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533395;
        bh=buHHJ69xvIOb5YrhxJ/UygH6NyR9N8Csyq2SaINp9DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2y+iIfzVojH8Qp/lRJOw3g8SDWmqi60ZroP9rYVBEDub+DU6BworUTW5Oqrk26c+
         mmbpvjUjqlivt0efG/9Zm4RxocHQgZeA7tSNZR2yHcvzQMJTRgPHT5bc9pSEacqxNF
         v4XhNJ376lCOkyMs5XRGhqWl3hF5/KJaTomna1Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/783] kbuild: remove unneeded mkdir for external modules_install
Date:   Thu, 12 Jan 2023 14:52:33 +0100
Message-Id: <20230112135544.551230621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4b97ec0e9cfd5995f41b9726c88566a31f4625cc ]

scripts/Makefile.modinst creates directories as needed.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: c7b98de745cf ("phy: qcom-qmp-combo: fix runtime suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Makefile b/Makefile
index 68f8efa0cc30..9be2a818d4d7 100644
--- a/Makefile
+++ b/Makefile
@@ -1746,10 +1746,8 @@ $(MODORDER): descend
 PHONY += modules_install
 modules_install: _emodinst_ _emodinst_post
 
-install-dir := $(if $(INSTALL_MOD_DIR),$(INSTALL_MOD_DIR),extra)
 PHONY += _emodinst_
 _emodinst_:
-	$(Q)mkdir -p $(MODLIB)/$(install-dir)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 PHONY += _emodinst_post
-- 
2.35.1



