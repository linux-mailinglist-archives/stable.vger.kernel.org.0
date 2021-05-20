Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ADB38A2F0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhETJr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233209AbhETJpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 383CE613D4;
        Thu, 20 May 2021 09:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503212;
        bh=jlHOIqEnKSZfx+DKjSDVsODchpEeE+sFQmL6i7It2I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohfRxvEKu4Dfjg+LeOPkiBnQiRBZGhja9u2gX8aAkqUIXVK+ftPYBgaVraOaAIWeL
         ShhR/wVVdRr5OMJucyVQIULIn0kQk0r+H1sNf25skygsoyxSjnor3eN6O1KkEQbyGZ
         8DT6B8LgLyQ0ukU7mIzpjfbIWDUAiYtix2rUxDSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 120/425] modules: mark find_symbol static
Date:   Thu, 20 May 2021 11:18:09 +0200
Message-Id: <20210520092135.383802887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -538,17 +538,6 @@ struct symsearch {
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
@@ -568,7 +568,7 @@ static bool find_symbol_in_section(const
 
 /* Find a symbol and return it, along with, (optional) crc and
  * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
-const struct kernel_symbol *find_symbol(const char *name,
+static const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const s32 **crc,
 					bool gplok,
@@ -591,7 +591,6 @@ const struct kernel_symbol *find_symbol(
 	pr_debug("Failed to find symbol %s\n", name);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(find_symbol);
 
 /*
  * Search for module by name: must hold module_mutex (or preempt disabled


