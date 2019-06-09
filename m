Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980A33A8E3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388380AbfFIRFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388788AbfFIRFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0374220833;
        Sun,  9 Jun 2019 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099918;
        bh=j/4mj41txbokL6sWtov/J2R9lrvZFfKMACDs23RHENM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpZn3YoqjytMmjN3m8OQEPZhZk7zIXWZtwkXFi15kWjQD7AQaRIm1er3JQzqCg7wB
         zkhKzQL0ubgua82/klhfXa97bscpxswoYggs9JnYElUSqM1OfFrOURNBYBwwNRpWqI
         0saOc5ba/UrcLAVDBK/o/UyO1RzPsZ5IFa9VINd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.4 213/241] CIFS: cifs_read_allocate_pages: dont iterate through whole page array on ENOMEM
Date:   Sun,  9 Jun 2019 18:42:35 +0200
Message-Id: <20190609164154.817633029@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -2829,7 +2829,9 @@ cifs_read_allocate_pages(struct cifs_rea
 	}
 
 	if (rc) {
-		for (i = 0; i < nr_pages; i++) {
+		unsigned int nr_page_failed = i;
+
+		for (i = 0; i < nr_page_failed; i++) {
 			put_page(rdata->pages[i]);
 			rdata->pages[i] = NULL;
 		}


