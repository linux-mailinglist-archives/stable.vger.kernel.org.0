Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42749378157
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhEJK0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhEJKZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B754161139;
        Mon, 10 May 2021 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642261;
        bh=3f0TJxPQjCm5jkHfdWHDx8VWCWYUkU4GnkBcEftDxho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fogTaaj0zTH0UuL9OtySWwLw3YWnSCR0NWQvmOUW5p6oyh177jGnbsMA1IlY6IpqC
         ydSXImEqYTMBhGjoW5D+Zlw1ddmG/PHdKuJJrlpKK1olEwzWBT0r9CkIcZd0oFPwBH
         dYefZkYsMSrynFi326xKdgRAS5LRCGX3Bc5jpySA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 024/184] modules: mark ref_module static
Date:   Mon, 10 May 2021 12:18:38 +0200
Message-Id: <20210510101951.028735728@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
@@ -636,7 +636,6 @@ static inline void __module_get(struct m
 #define symbol_put_addr(p) do { } while (0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
-int ref_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -867,7 +867,7 @@ static int add_module_usage(struct modul
 }
 
 /* Module a uses b: caller needs module_mutex() */
-int ref_module(struct module *a, struct module *b)
+static int ref_module(struct module *a, struct module *b)
 {
 	int err;
 
@@ -886,7 +886,6 @@ int ref_module(struct module *a, struct
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ref_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -1167,11 +1166,10 @@ static inline void module_unload_free(st
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


