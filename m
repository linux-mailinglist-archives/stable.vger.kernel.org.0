Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8A29C470
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823013AbgJ0R4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901238AbgJ0OVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B1B2206FA;
        Tue, 27 Oct 2020 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808492;
        bh=HZEflZcPzytj0oE3sdNwYUh5+hNkLcYjgHHNTEKAvvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gT9TdUjjtr/UQbHanLk0J0cAmSolgtFrXIvItF8Vz1BwcSObXwpa0V4hipT03ok9i
         FosLjheoOf0yRcRdZTPXAVrjt2eRpwHbyAKwxx3ySvEjaSpZkRcf2xG3KQp841tftP
         JjnSUuuyo4106rTqYk6KUXwCcRsTzMHb1o5X2fhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Dewar <alex.dewar90@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/264] VMCI: check return value of get_user_pages_fast() for errors
Date:   Tue, 27 Oct 2020 14:52:20 +0100
Message-Id: <20201027135434.552317357@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>

[ Upstream commit 90ca6333fd65f318c47bff425e1ea36c0a5539f6 ]

In a couple of places in qp_host_get_user_memory(),
get_user_pages_fast() is called without properly checking for errors. If
e.g. -EFAULT is returned, this negative value will then be passed on to
qp_release_pages(), which expects a u64 as input.

Fix this by only calling qp_release_pages() when we have a positive
number returned.

Fixes: 06164d2b72aa ("VMCI: queue pairs implementation.")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Link: https://lore.kernel.org/r/20200825164522.412392-1-alex.dewar90@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index bd52f29b4a4e2..5e0d1ac67f73f 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -671,8 +671,9 @@ static int qp_host_get_user_memory(u64 produce_uva,
 	if (retval < (int)produce_q->kernel_if->num_pages) {
 		pr_debug("get_user_pages_fast(produce) failed (retval=%d)",
 			retval);
-		qp_release_pages(produce_q->kernel_if->u.h.header_page,
-				 retval, false);
+		if (retval > 0)
+			qp_release_pages(produce_q->kernel_if->u.h.header_page,
+					retval, false);
 		err = VMCI_ERROR_NO_MEM;
 		goto out;
 	}
@@ -683,8 +684,9 @@ static int qp_host_get_user_memory(u64 produce_uva,
 	if (retval < (int)consume_q->kernel_if->num_pages) {
 		pr_debug("get_user_pages_fast(consume) failed (retval=%d)",
 			retval);
-		qp_release_pages(consume_q->kernel_if->u.h.header_page,
-				 retval, false);
+		if (retval > 0)
+			qp_release_pages(consume_q->kernel_if->u.h.header_page,
+					retval, false);
 		qp_release_pages(produce_q->kernel_if->u.h.header_page,
 				 produce_q->kernel_if->num_pages, false);
 		err = VMCI_ERROR_NO_MEM;
-- 
2.25.1



