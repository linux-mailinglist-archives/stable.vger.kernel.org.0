Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB46088E3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiJVIXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiJVIW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:22:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C623B956;
        Sat, 22 Oct 2022 00:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 597F3B82DFA;
        Sat, 22 Oct 2022 07:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47DC433D6;
        Sat, 22 Oct 2022 07:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425552;
        bh=vu7rJYj1z+XfoxBx4lR0BrFlu16v+YMPOdlO7pyXxkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1XiWn27v3kSFkQTfDxiw0z0eaZQ/jnqlo8kURX0UtiEHhxDZ0i5bIxvm4vg3jNoW
         q2+QMxaLMJmZ4zc67brD4MyLXGoeywjq6h473os0xsdjL9a49+aIc5ypVyemB9VBkB
         XlNNuUrL7cLtPTg67eIR1FJmT5UpHscc2hOilj6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 539/717] module: tracking: Keep a record of tainted unloaded modules only
Date:   Sat, 22 Oct 2022 09:26:58 +0200
Message-Id: <20221022072522.179159829@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



