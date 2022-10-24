Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CC60A5FE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiJXMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiJXM3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E388A00;
        Mon, 24 Oct 2022 05:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E7EB81203;
        Mon, 24 Oct 2022 12:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B782C433B5;
        Mon, 24 Oct 2022 12:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612822;
        bh=7S74saqVx1Z5JOwQfwfMYXqdxLHiFdAxBPFGunevnug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDeFgPvZ6jJiu+dLYLb0vaGxGpAXtlmcShaCxfTc9HJYsE6CIVjXQ+tCZN8pRAce/
         ZBIy+R2GbykN54oFA3L1/fD3HsU54yyvuWE8UD42fLCo3l6FJUhSijfpWZlnyY2hcP
         8pbGu/IJcapl9RDpavO7oVNq9euuAmeajwd0CD+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jason Baron <jbaron@akamai.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/229] dyndbg: fix module.dyndbg handling
Date:   Mon, 24 Oct 2022 13:30:52 +0200
Message-Id: <20221024113003.300400201@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit 85d6b66d31c35158364058ee98fb69ab5bb6a6b1 ]

For CONFIG_DYNAMIC_DEBUG=N, the ddebug_dyndbg_module_param_cb()
stub-fn is too permissive:

bash-5.1# modprobe drm JUNKdyndbg
bash-5.1# modprobe drm dyndbgJUNK
[   42.933220] dyndbg param is supported only in CONFIG_DYNAMIC_DEBUG builds
[   42.937484] ACPI: bus type drm_connector registered

This caused no ill effects, because unknown parameters are either
ignored by default with an "unknown parameter" warning, or ignored
because dyndbg allows its no-effect use on non-dyndbg builds.

But since the code has an explicit feedback message, it should be
issued accurately.  Fix with strcmp for exact param-name match.

Fixes: b48420c1d301 dynamic_debug: make dynamic-debug work for module initialization
Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Jason Baron <jbaron@akamai.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20220904214134.408619-3-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dynamic_debug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index b3419da1a776..77a16b2eb42f 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -168,7 +168,7 @@ static inline int ddebug_remove_module(const char *mod)
 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 						const char *modname)
 {
-	if (strstr(param, "dyndbg")) {
+	if (!strcmp(param, "dyndbg")) {
 		/* avoid pr_warn(), which wants pr_fmt() fully defined */
 		printk(KERN_WARNING "dyndbg param is supported only in "
 			"CONFIG_DYNAMIC_DEBUG builds\n");
-- 
2.35.1



