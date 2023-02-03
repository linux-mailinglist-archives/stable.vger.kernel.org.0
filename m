Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DF66894E4
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjBCKP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBCKP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FFB903BC
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7B89B82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185DEC433EF;
        Fri,  3 Feb 2023 10:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419323;
        bh=COg3Lcz4kAJDcAA71w0um+JBdb3/nhWqDuK3huaOPsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSaIjaOH8WsAa1nVEnYb4xUXCd0Fs1VLrZaJmfu4eZf4itp9KuH6qFjy6lMnNRVO+
         byG+3xnDtNmo/eByDw6KXOuP+LnIMK3YUzGhnBA6zZFkP7YRHxr4eFMLXu5L7kT8s7
         4TIZwpvPX73w5SwU3D5sgGcgRUe0NyJXB2U/nC/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/62] tomoyo: fix broken dependency on *.conf.default
Date:   Fri,  3 Feb 2023 11:12:00 +0100
Message-Id: <20230203101013.176898015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
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
index b7c6a7ffc058..a1ecf68930c7 100644
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



