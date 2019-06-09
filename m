Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01203AAC5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbfFIQpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbfFIQps (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE7C20833;
        Sun,  9 Jun 2019 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098747;
        bh=3QIcKu0AVrUSUlmPC59YAtlLMAzQkttuqt2FFBAOSwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEBEtNTn1N6NIvsz9kBY84ySVtzWqMRe3vTPwDoJD+Fu18SH32hyza7KGI/fMmprx
         7HvgKJVDFDNsHMn5dbYjRRK/0tScv2YeBDOz/a3H1neeS6IIYjgJADDhawp3cTh5gR
         2GgW6HNTs80ui+g5YnVoWBRR5XdR78hfBODXDkks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.1 47/70] genwqe: Prevent an integer overflow in the ioctl
Date:   Sun,  9 Jun 2019 18:41:58 +0200
Message-Id: <20190609164131.329221760@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 110080cea0d0e4dfdb0b536e7f8a5633ead6a781 upstream.

There are a couple potential integer overflows here.

	round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);

The first thing is that the "m->size + (...)" addition could overflow,
and the second is that round_up() overflows to zero if the result is
within PAGE_SIZE of the type max.

In this code, the "m->size" variable is an u64 but we're saving the
result in "map_size" which is an unsigned long and genwqe_user_vmap()
takes an unsigned long as well.  So I have used ULONG_MAX as the upper
bound.  From a practical perspective unsigned long is fine/better than
trying to change all the types to u64.

Fixes: eaf4722d4645 ("GenWQE Character device and DDCB queue")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/genwqe/card_dev.c   |    2 ++
 drivers/misc/genwqe/card_utils.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -780,6 +780,8 @@ static int genwqe_pin_mem(struct genwqe_
 
 	if ((m->addr == 0x0) || (m->size == 0))
 		return -EINVAL;
+	if (m->size > ULONG_MAX - PAGE_SIZE - (m->addr & ~PAGE_MASK))
+		return -EINVAL;
 
 	map_addr = (m->addr & PAGE_MASK);
 	map_size = round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -586,6 +586,10 @@ int genwqe_user_vmap(struct genwqe_dev *
 	/* determine space needed for page_list. */
 	data = (unsigned long)uaddr;
 	offs = offset_in_page(data);
+	if (size > ULONG_MAX - PAGE_SIZE - offs) {
+		m->size = 0;	/* mark unused and not added */
+		return -EINVAL;
+	}
 	m->nr_pages = DIV_ROUND_UP(offs + size, PAGE_SIZE);
 
 	m->page_list = kcalloc(m->nr_pages,


