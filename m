Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F11B21FCDD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgGNSrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgGNSrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB80F22AAA;
        Tue, 14 Jul 2020 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752452;
        bh=YZXuyh1eSZoyDT5f0ILiSyJB2BJsH+OqjQCOv45XoIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qI4EB0PZvxNCDFg9u2JaL9BY7kUnDcxos64vA0MVoB47tRMu4yKqG9zLzmkD/Aeff
         kUU6uTLhYtznCH9JxC/CnxbpaDFWL2UZXQQptcqT8YHavdsS0Q6oC6hGB8UdkoRCAI
         UV8iXQe6GULt/LXCq/ItIx+sro8qTBfVAZ6p9PyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 47/58] kernel: module: Use struct_size() helper
Date:   Tue, 14 Jul 2020 20:44:20 +0200
Message-Id: <20200714184058.494015284@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 8d1b73dd25ff92c3fa9807a20c22fa2b44c07336 upstream.

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct module_sect_attrs {
	...
        struct module_sect_attr attrs[0];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following form:

sizeof(*sect_attrs) + nloaded * sizeof(sect_attrs->attrs[0]

with:

struct_size(sect_attrs, attrs, nloaded)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1491,8 +1491,7 @@ static void add_sect_attrs(struct module
 	for (i = 0; i < info->hdr->e_shnum; i++)
 		if (!sect_empty(&info->sechdrs[i]))
 			nloaded++;
-	size[0] = ALIGN(sizeof(*sect_attrs)
-			+ nloaded * sizeof(sect_attrs->attrs[0]),
+	size[0] = ALIGN(struct_size(sect_attrs, attrs, nloaded),
 			sizeof(sect_attrs->grp.attrs[0]));
 	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
 	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);


