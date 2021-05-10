Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45EC378159
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhEJK0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhEJKZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C576144E;
        Mon, 10 May 2021 10:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642266;
        bh=BK3Vwu3F0W2ERslbnzkcnEJgOqjgPmxd10sGnp7XoiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvDQCPgr3B6v74WsfkbjOsdk+wSQ3UGfviGOKVvAnyQ5Au4EUlhlfEhk58UFfkWbs
         YdFtpBNxGcknG2igM5LJwB5SnteFZ/Cr8aZtwMuZ7mLTfFBj21FYG4tV296i7PxX6s
         kasbFfcqAk6RAKyuNrYW1HPtVkMxakHqiaeomkPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 026/184] modules: mark each_symbol_section static
Date:   Mon, 10 May 2021 12:18:40 +0200
Message-Id: <20210510101951.095772461@linuxfoundation.org>
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
@@ -569,15 +569,6 @@ struct symsearch {
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
@@ -420,7 +420,7 @@ static bool each_symbol_in_section(const
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
+static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 				    struct module *owner,
 				    void *data),
 			 void *data)
@@ -482,7 +482,6 @@ bool each_symbol_section(bool (*fn)(cons
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol_section);
 
 struct find_symbol_arg {
 	/* Input */


