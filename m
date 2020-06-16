Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1571FB6A8
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgFPPjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730894AbgFPPjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060E62166E;
        Tue, 16 Jun 2020 15:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321956;
        bh=5/lH2KRzHCeETvLwWO2Es2Pqsk6+CLgbLIvVr3d8lLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4X+X//hF/x9XYq0NJfwVe+ClvcEm5FWs5HLBeQY1Oa4CNIip/yXzkGmqwahofGB9
         aItn9EbQlSTALd0IZJfLbKICSfL7FBA/HyOBBUlYs7v8nydgCE/Z8zJtUiJGWlSHek
         HbLY7818DNcZ1BFL0pss6F+VDObufx+mwHbgJ5io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 050/134] io_uring: use kvfree() in io_sqe_buffer_register()
Date:   Tue, 16 Jun 2020 17:33:54 +0200
Message-Id: <20200616153103.181618765@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit a8c73c1a614f6da6c0b04c393f87447e28cb6de4 upstream.

Use kvfree() to free the pages and vmas, since they are allocated by
kvmalloc_array() in a loop.

Fixes: d4ef647510b1 ("io_uring: avoid page allocation warnings")
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200605093203.40087-1-efremov@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3498,8 +3498,8 @@ static int io_sqe_buffer_register(struct
 
 		ret = 0;
 		if (!pages || nr_pages > got_pages) {
-			kfree(vmas);
-			kfree(pages);
+			kvfree(vmas);
+			kvfree(pages);
 			pages = kvmalloc_array(nr_pages, sizeof(struct page *),
 						GFP_KERNEL);
 			vmas = kvmalloc_array(nr_pages,


