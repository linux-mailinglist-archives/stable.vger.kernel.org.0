Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89CA60B052
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiJXQFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiJXQDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:03:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A11303E5;
        Mon, 24 Oct 2022 07:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 409BFB81205;
        Mon, 24 Oct 2022 12:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D427C433C1;
        Mon, 24 Oct 2022 12:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614344;
        bh=j48GD4wqmvfik3nas3KYqwYEPabup8cKXd1O2oBA5/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr4I7BISfdTdcRMhLeMSx1REJ+L5CtbNrvMvfWkGCuNNHWEht79OBoahdvu+ngMLJ
         vkzVYVYlEjxG+vNIczjCcd9aRxdHubwB900URiGMTKm9WN3AbY90xZrel3+4WXhiI+
         rwFgZSJUIZsqvIq8sej7/3MRCBTePnNhgfUQ1IGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jason Baron <jbaron@akamai.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/390] dyndbg: fix module.dyndbg handling
Date:   Mon, 24 Oct 2022 13:30:15 +0200
Message-Id: <20221024113032.065724366@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index a57ee75342cf..b0b23679b2c2 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -196,7 +196,7 @@ static inline int ddebug_remove_module(const char *mod)
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



