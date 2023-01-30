Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D0A681301
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbjA3O1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjA3O0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2F63F2B8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A659FCE1712
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863DBC433EF;
        Mon, 30 Jan 2023 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088420;
        bh=ZOHy4zDgMFlK6xjhcbJMwUmPeR8ZEwcxRMhxMNPe9/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B62qECO7pnWaPkqgBzKF6YEXBUzHBj4tWU3zXqznYmY3FStfRb0MAu+pZQXtpSbvi
         dCwF6T9qNvTH5v0K9yt1lqzDqyeZf9GHC7zs7nc7RBV66UPDYOtDIcwI0iMR991/L0
         8y/suHTonQB2NiYwsKwx3mFLED1TXq9tKWDIJ3sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/143] tomoyo: fix broken dependency on *.conf.default
Date:   Mon, 30 Jan 2023 14:51:11 +0100
Message-Id: <20230130134307.473206261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit eaf2213ba563b2d74a1f2c13a6b258273f689802 ]

If *.conf.default is updated, builtin-policy.h should be rebuilt,
but this does not work when compiled with O= option.

[Without this commit]

  $ touch security/tomoyo/policy/exception_policy.conf.default
  $ make O=/tmp security/tomoyo/
  make[1]: Entering directory '/tmp'
    GEN     Makefile
    CALL    /home/masahiro/ref/linux/scripts/checksyscalls.sh
    DESCEND objtool
  make[1]: Leaving directory '/tmp'

[With this commit]

  $ touch security/tomoyo/policy/exception_policy.conf.default
  $ make O=/tmp security/tomoyo/
  make[1]: Entering directory '/tmp'
    GEN     Makefile
    CALL    /home/masahiro/ref/linux/scripts/checksyscalls.sh
    DESCEND objtool
    POLICY  security/tomoyo/builtin-policy.h
    CC      security/tomoyo/common.o
    AR      security/tomoyo/built-in.a
  make[1]: Leaving directory '/tmp'

$(srctree)/ is essential because $(wildcard ) does not follow VPATH.

Fixes: f02dee2d148b ("tomoyo: Do not generate empty policy files")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index cca5a3012fee..221eaadffb09 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -10,7 +10,7 @@ endef
 quiet_cmd_policy  = POLICY  $@
       cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
 
-$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(src)/policy/*.conf.default) FORCE
+$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(srctree)/$(src)/policy/*.conf.default) FORCE
 	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
-- 
2.39.0



