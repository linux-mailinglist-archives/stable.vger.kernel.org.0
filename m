Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98F0603EC6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiJSJUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiJSJTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBA8DBE7C;
        Wed, 19 Oct 2022 02:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E5516187F;
        Wed, 19 Oct 2022 09:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8061AC433D6;
        Wed, 19 Oct 2022 09:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170451;
        bh=vu7rJYj1z+XfoxBx4lR0BrFlu16v+YMPOdlO7pyXxkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyXAqdqac90ZmB1MepO//b2fHO5VewApjA0nM1EdRMLgyMBM+NOR9jt7FlypDYvV0
         FB365IlwZBwif0uMjxkE9XU9jJbEgeP5bhg0jnL+rsHf52Oq96H8dB1wZSbMeZTyfj
         r0tWp4gSTD4r1JA6305ZH5Jccpb6tgND98xH2s0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 660/862] module: tracking: Keep a record of tainted unloaded modules only
Date:   Wed, 19 Oct 2022 10:32:27 +0200
Message-Id: <20221019083319.135652075@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

[ Upstream commit 47cc75aa92837a9d3f15157d6272ff285585d75d ]

This ensures that no module record/or entry is added to the
unloaded_tainted_modules list if it does not carry a taint.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: 99bd9956551b ("module: Introduce module unload taint tracking")
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/tracking.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/module/tracking.c b/kernel/module/tracking.c
index 7f8133044d09..af52cabfe632 100644
--- a/kernel/module/tracking.c
+++ b/kernel/module/tracking.c
@@ -21,6 +21,9 @@ int try_add_tainted_module(struct module *mod)
 
 	module_assert_mutex_or_preempt();
 
+	if (!mod->taints)
+		goto out;
+
 	list_for_each_entry_rcu(mod_taint, &unloaded_tainted_modules, list,
 				lockdep_is_held(&module_mutex)) {
 		if (!strcmp(mod_taint->name, mod->name) &&
-- 
2.35.1



