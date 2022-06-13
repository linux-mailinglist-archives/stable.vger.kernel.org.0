Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25F548DA1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381787AbiFMOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381470AbiFMOL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:11:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE539A983;
        Mon, 13 Jun 2022 04:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F69B80EDE;
        Mon, 13 Jun 2022 11:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B03C34114;
        Mon, 13 Jun 2022 11:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120523;
        bh=RAPHGV+rtvwWQJEXunWfr637QO4/abkhlqk7qVnMv14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhTEIv/z40GCSERNGwcRTsuOmbOfhEDmHleYt9nNrvGYdZgoJIG3wqS+FGyOUlQhR
         EB8Ku/XuZ8/888qyraWqEhB3h9E8epoPy0u5l5mRa7S2CXAIF72WARBveJfjNgHKtY
         oQcE9ItCWvkxwMqn4f8izGtAvmP88sfkBmV5Yl0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Jessica Yu <jeyu@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Matthias Maennich <maennich@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 040/298] export: fix string handling of namespace in EXPORT_SYMBOL_NS
Date:   Mon, 13 Jun 2022 12:08:54 +0200
Message-Id: <20220613094926.154151769@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit d143b9db8069f0e2a0fa34484e806a55a0dd4855 ]

Commit c3a6cf19e695 ("export: avoid code duplication in
include/linux/export.h") broke the ability for a defined string to be
used as a namespace value.  Fix this up by using stringify to properly
encode the namespace name.

Fixes: c3a6cf19e695 ("export: avoid code duplication in include/linux/export.h")
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Matthias Maennich <maennich@google.com>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20220427090442.2105905-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/export.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/export.h b/include/linux/export.h
index 27d848712b90..5910ccb66ca2 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_EXPORT_H
 #define _LINUX_EXPORT_H
 
+#include <linux/stringify.h>
+
 /*
  * Export symbols from the kernel to modules.  Forked from module.h
  * to reduce the amount of pointless cruft we feed to gcc when only
@@ -154,7 +156,6 @@ struct kernel_symbol {
 #endif /* CONFIG_MODULES */
 
 #ifdef DEFAULT_SYMBOL_NAMESPACE
-#include <linux/stringify.h>
 #define _EXPORT_SYMBOL(sym, sec)	__EXPORT_SYMBOL(sym, sec, __stringify(DEFAULT_SYMBOL_NAMESPACE))
 #else
 #define _EXPORT_SYMBOL(sym, sec)	__EXPORT_SYMBOL(sym, sec, "")
@@ -162,8 +163,8 @@ struct kernel_symbol {
 
 #define EXPORT_SYMBOL(sym)		_EXPORT_SYMBOL(sym, "")
 #define EXPORT_SYMBOL_GPL(sym)		_EXPORT_SYMBOL(sym, "_gpl")
-#define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", #ns)
-#define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "_gpl", #ns)
+#define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", __stringify(ns))
+#define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "_gpl", __stringify(ns))
 
 #endif /* !__ASSEMBLY__ */
 
-- 
2.35.1



