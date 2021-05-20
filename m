Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293DE38A63E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhETKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234974AbhETKXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EBC661A13;
        Thu, 20 May 2021 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504122;
        bh=RG4v/wlVitSLVQk1sTkYyzTmq/0GmHoCWdtA1dAytkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTiZeUZ8JmGjT7zbhs8D7us/b2l8TuwBNt2GFbxmKDBs3yV97hEGr11S609nfRU0j
         UwaHJKHrbJE+6yJJTkO8OW0uDWnbMU7+SPyRDBi5wqMXPcSCFukFmcb+z663X3uipl
         gxaHGxXsCgAHxVqmu6/C2m5vZjVJuowNBlDwSlDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.14 103/323] modules: mark ref_module static
Date:   Thu, 20 May 2021 11:19:55 +0200
Message-Id: <20210520092123.631404940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7ef5264de773279b9f23b6cc8afb5addb30e970b upstream.

ref_module isn't used anywhere outside of module.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |    1 -
 kernel/module.c        |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -597,7 +597,6 @@ static inline void __module_get(struct m
 #define symbol_put_addr(p) do { } while (0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
-int ref_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -850,7 +850,7 @@ static int add_module_usage(struct modul
 }
 
 /* Module a uses b: caller needs module_mutex() */
-int ref_module(struct module *a, struct module *b)
+static int ref_module(struct module *a, struct module *b)
 {
 	int err;
 
@@ -869,7 +869,6 @@ int ref_module(struct module *a, struct
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ref_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -1150,11 +1149,10 @@ static inline void module_unload_free(st
 {
 }
 
-int ref_module(struct module *a, struct module *b)
+static int ref_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b);
 }
-EXPORT_SYMBOL_GPL(ref_module);
 
 static inline int module_unload_init(struct module *mod)
 {


