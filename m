Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172C302AD9
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbhAYSy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731304AbhAYSx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51A822482;
        Mon, 25 Jan 2021 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600822;
        bh=rxcBrCVXrL9+tljwdhsfBzOEJPHtMx00KvYbesaFMjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwoWO9e/VmKDejRNY7U4pGJe41aoCw3ws6609FUdGiwkqd9UNEDM1YtXn/T2pMSB/
         ho4JvrSABOp+qpectY1TVSDEwd/T+Mf1MoP7Ri38QLuumt5pFvKLMy9Oi9JX/EanWG
         YAcq+6VeMAfMXF6grJIdSeHU1l3ppwIgrN2zN0nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 165/199] lightnvm: fix memory leak when submit fails
Date:   Mon, 25 Jan 2021 19:39:47 +0100
Message-Id: <20210125183223.159137580@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 97784481757fba7570121a70dd37ca74a29f50a8 upstream.

The allocated page is not released if error occurs in
nvm_submit_io_sync_raw(). __free_page() is moved ealier to avoid
possible memory leak issue.

Fixes: aff3fb18f957 ("lightnvm: move bad block and chunk state logic to core")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/lightnvm/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -844,11 +844,10 @@ static int nvm_bb_chunk_sense(struct nvm
 	rqd.ppa_addr = generic_to_dev_addr(dev, ppa);
 
 	ret = nvm_submit_io_sync_raw(dev, &rqd);
+	__free_page(page);
 	if (ret)
 		return ret;
 
-	__free_page(page);
-
 	return rqd.error;
 }
 


