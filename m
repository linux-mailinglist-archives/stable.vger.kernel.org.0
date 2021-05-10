Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BADB378158
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhEJK0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231264AbhEJKZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4BE61424;
        Mon, 10 May 2021 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642263;
        bh=IheVTynqrhnWOYwBtAg8P8RBcLM7UkbYeuJjZqqHlsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXxxYjC5/xB55pKFs+GEhJ1xWnhFxaFpgBkzrqTb6M8WooinquqtchuAUpTWFV9vr
         T5Q0nk1GffZRlKVNRbbLQ9d8LSyc43fHTf/EvraVtX7LHzomEpK3u07Z2ZcJ6EEC9G
         TVcJDE0wPJsaNzBKEFdhFHapggNV3GXbGmSH3Q/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 025/184] modules: mark find_symbol static
Date:   Mon, 10 May 2021 12:18:39 +0200
Message-Id: <20210510101951.063353671@linuxfoundation.org>
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

commit 773110470e2fa3839523384ae014f8a723c4d178 upstream.

find_symbol is only used in module.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |   11 -----------
 kernel/module.c        |    3 +--
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -570,17 +570,6 @@ struct symsearch {
 };
 
 /*
- * Search for an exported symbol by name.
- *
- * Must be called with module_mutex held or preemption disabled.
- */
-const struct kernel_symbol *find_symbol(const char *name,
-					struct module **owner,
-					const s32 **crc,
-					bool gplok,
-					bool warn);
-
-/*
  * Walk the exported symbol table
  *
  * Must be called with module_mutex held or preemption disabled.
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -583,7 +583,7 @@ static bool find_exported_symbol_in_sect
 
 /* Find an exported symbol and return it, along with, (optional) crc and
  * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
-const struct kernel_symbol *find_symbol(const char *name,
+static const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const s32 **crc,
 					bool gplok,
@@ -606,7 +606,6 @@ const struct kernel_symbol *find_symbol(
 	pr_debug("Failed to find symbol %s\n", name);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(find_symbol);
 
 /*
  * Search for module by name: must hold module_mutex (or preempt disabled


