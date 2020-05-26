Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5009C1E2E10
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390043AbgEZT0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390567AbgEZTF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF91020873;
        Tue, 26 May 2020 19:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519926;
        bh=A3fRN3AR8YfQriSsm/PCZQ3OvmIXfqBFJtq7KEdnWRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkgk80EdMTp+DV0qXWxtJow/VtxpJIyjGJsa4XHaDHAFuFMfDuut8Wn2xj8hd1bn5
         QPSLNTvqgBnA6x6qK87JAWMjF2kZqOFgvQtgXAtr/Dtv1EJ/wx/cyiHyJaPZSp9dUi
         qU4hQitW9YGTBORSZKc2jAgwiEKKryBcpW3rPUQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 72/81] rapidio: fix an error in get_user_pages_fast() error handling
Date:   Tue, 26 May 2020 20:53:47 +0200
Message-Id: <20200526183935.038966976@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit ffca476a0a8d26de767cc41d62b8ca7f540ecfdd upstream.

In the case of get_user_pages_fast() returning fewer pages than
requested, rio_dma_transfer() does not quite do the right thing.  It
attempts to release all the pages that were requested, rather than just
the pages that were pinned.

Fix the error handling so that only the pages that were successfully
pinned are released.

Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200517235620.205225-2-jhubbard@nvidia.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -879,6 +879,11 @@ rio_dma_transfer(struct file *filp, u32
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
 			ret = -EFAULT;
+			/*
+			 * Set nr_pages up to mean "how many pages to unpin, in
+			 * the error handler:
+			 */
+			nr_pages = pinned;
 			goto err_pg;
 		}
 


