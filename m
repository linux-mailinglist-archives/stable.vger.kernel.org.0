Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA325206333
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbgFWUTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388340AbgFWUTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EE72073E;
        Tue, 23 Jun 2020 20:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943542;
        bh=6AeVktJdntFAJwJ3fr6pWD7n9+9pDRAiwi9nImVA07Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlaTqKiA0p3wyBoxnoK1UrRKWfWAcE5wRCmJ9fCmwFX9vJ4fKj3HmsVxpc+sfTcKV
         xckh6Hs4/CySeNtl+SN7FurvxdOjnQc9XolL1/pjjBM7r3+d14V1d3uyPC0EUIHTf5
         NfG1UFUHoKwcQBcoEuw7rwxSvzpQBli0p9d9rTFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 431/477] io_uring: dont fail links for EAGAIN error in IOPOLL mode
Date:   Tue, 23 Jun 2020 21:57:08 +0200
Message-Id: <20200623195427.903831560@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit 2d7d67920e5c8e0854df23ca77da2dd5880ce5dd ]

In IOPOLL mode, for EAGAIN error, we'll try to submit io request
again using io-wq, so don't fail rest of links if this io request
has links.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1936,7 +1936,7 @@ static void io_complete_rw_iopoll(struct
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if (res != req->result)
+	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)


