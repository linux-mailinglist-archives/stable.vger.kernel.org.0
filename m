Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722D938A63F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhETKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235534AbhETKXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3624613FC;
        Thu, 20 May 2021 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504127;
        bh=imkrRNpHPT9319ALNjIqK0doJwrQywERK3aPwXUzPVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjM+n+Hglghum5FyaVO8JmSXO+yTDjTGNVwKb+TokF7vc9G9bNzcZzJ5LC0sraU+c
         d21yTxqzOZVWBkrM2nreSrn2cGk1XwwCgQ63UFWeXG3a/49Lf7qs3D+OM1+sM4025M
         1bpqFnQhREyriwbWjiEddFMPxQIeMiLOb6BORp0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.14 105/323] modules: mark each_symbol_section static
Date:   Thu, 20 May 2021 11:19:57 +0200
Message-Id: <20210520092123.699096710@linuxfoundation.org>
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

commit a54e04914c211b5678602a46b3ede5d82ec1327d upstream.

each_symbol_section is only used inside of module.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |    9 ---------
 kernel/module.c        |    3 +--
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -530,15 +530,6 @@ struct symsearch {
 	bool unused;
 };
 
-/*
- * Walk the exported symbol table
- *
- * Must be called with module_mutex held or preemption disabled.
- */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
-				    struct module *owner,
-				    void *data), void *data);
-
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -430,7 +430,7 @@ static bool each_symbol_in_section(const
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
+static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 				    struct module *owner,
 				    void *data),
 			 void *data)
@@ -491,7 +491,6 @@ bool each_symbol_section(bool (*fn)(cons
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol_section);
 
 struct find_symbol_arg {
 	/* Input */


