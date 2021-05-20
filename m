Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CEA38A2F1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhETJr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhETJp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF3D61455;
        Thu, 20 May 2021 09:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503214;
        bh=AnK2O5MtKC736R/1fqopfArhNgbm8iz7LT8UI2k9E8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAHqpSQJzPr7PHoDAzW/pm3jXMry3fSeYxUa3Xx25Erb9e5OgpvTCPurspVd4W5Zi
         tbIPZzMfkaD5i+TIJBFjM1TikgZT6K0W2DTpbIbFrC4HdX+9ZfpcvfAqqhtRG3FyyB
         HSY1x7xAhkiS/1PSeFSQv+oC4s/M/6FPPXv7u1Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 121/425] modules: mark each_symbol_section static
Date:   Thu, 20 May 2021 11:18:10 +0200
Message-Id: <20210520092135.415136122@linuxfoundation.org>
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
@@ -537,15 +537,6 @@ struct symsearch {
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
@@ -415,7 +415,7 @@ static bool each_symbol_in_section(const
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
+static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 				    struct module *owner,
 				    void *data),
 			 void *data)
@@ -476,7 +476,6 @@ bool each_symbol_section(bool (*fn)(cons
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol_section);
 
 struct find_symbol_arg {
 	/* Input */


