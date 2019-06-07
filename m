Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6442B3905A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbfFGPut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732219AbfFGPut (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D53214AE;
        Fri,  7 Jun 2019 15:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922648;
        bh=iZR+1QcezVqXwWvl1sWCJiRdgYjq3LXYc5UxfNw24sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQJVz5/FovjzeVFbHSx4pMo+mXbX6RBXgp1u82/ldVTGNYyXTcJxa2A+jNTJW09he
         fZbXWBoe1bZtRjG7r9DblndGidgw3897LN7djy22GDQzOHrjkaWgcktAFieQY91nEy
         kF+0oQP/grGJQjUuW9qfep1ZE0R+/JDrb57xD/FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 68/85] CIFS: cifs_read_allocate_pages: dont iterate through whole page array on ENOMEM
Date:   Fri,  7 Jun 2019 17:39:53 +0200
Message-Id: <20190607153856.765606620@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

commit 31fad7d41e73731f05b8053d17078638cf850fa6 upstream.

 In cifs_read_allocate_pages, in case of ENOMEM, we go through
whole rdata->pages array but we have failed the allocation before
nr_pages, therefore we may end up calling put_page with NULL
pointer, causing oops

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3221,7 +3221,9 @@ cifs_read_allocate_pages(struct cifs_rea
 	}
 
 	if (rc) {
-		for (i = 0; i < nr_pages; i++) {
+		unsigned int nr_page_failed = i;
+
+		for (i = 0; i < nr_page_failed; i++) {
 			put_page(rdata->pages[i]);
 			rdata->pages[i] = NULL;
 		}


