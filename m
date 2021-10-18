Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804C5431EB9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhJROFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234818AbhJRODS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A74F3610A6;
        Mon, 18 Oct 2021 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564611;
        bh=/+fv3M6e4tZV0XEHFtkrthpnHFGfVGANl86RrK2DDG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfZrcrrw5uBViRt/p3r+DTO2Y+CZZD100rozmBOMrgUnKYy2plECzfIl+bnhs7mLC
         rUFPPeWF4hftTWZm/6aIrS91fc+QdSMN4wDfBlqvbgTfnu43Prbt+w61wmKIJZmmWK
         ZiuYhWgx5pRX5iopUF/44k/f8N5y+SKmIzBXYYIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gioh Kim <gi-oh.kim@ionos.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 143/151] block/rnbd-clt-sysfs: fix a couple uninitialized variable bugs
Date:   Mon, 18 Oct 2021 15:25:22 +0200
Message-Id: <20211018132345.308431405@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7904022decc260a19dd65b56ac896387f5da6f8c upstream.

These variables are printed on the error path if match_int() fails so
they have to be initialized.

Fixes: 2958a995edc9 ("block/rnbd-clt: Support polling mode for IO latency optimization")
Fixes: 1eb54f8f5dd8 ("block/rnbd: client: sysfs interface functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Gioh Kim <gi-oh.kim@ionos.com>
Link: https://lore.kernel.org/r/20211012084443.GA31472@kili
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -71,8 +71,10 @@ static int rnbd_clt_parse_map_options(co
 	int opt_mask = 0;
 	int token;
 	int ret = -EINVAL;
-	int i, dest_port, nr_poll_queues;
+	int nr_poll_queues = 0;
+	int dest_port = 0;
 	int p_cnt = 0;
+	int i;
 
 	options = kstrdup(buf, GFP_KERNEL);
 	if (!options)


