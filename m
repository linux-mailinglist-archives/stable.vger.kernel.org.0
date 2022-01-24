Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA2B49957A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441973AbiAXUw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41754 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391341AbiAXUr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA42C60B11;
        Mon, 24 Jan 2022 20:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84496C340E5;
        Mon, 24 Jan 2022 20:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057247;
        bh=jV0MshI0Oglx5/JEM82uxpfw09EeJcTyjtUKUjYzzBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGRHszkwpX0nyq+OHqGtdRbxXVLLoprmH9eEoVLDqPRiBQ89jAVVigbR89jq5xXJ7
         gva1jN26Qm605uPBIInmM0ZWhuzlXJXkhAHUwoi0wJjozLQn2ABtcRRgZgol8RNj38
         UoRUc79hDKnkOLNNpgFYtbkuBJGPt/DdDzfsvQY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 748/846] RDMA/cma: Remove open coding of overflow checking for private_data_len
Date:   Mon, 24 Jan 2022 19:44:25 +0100
Message-Id: <20220124184126.787599256@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

commit 8d0d2b0f41b1b2add8a30dbd816051a964efa497 upstream.

The existing tests are a little hard to comprehend. Use
check_add_overflow() instead.

Fixes: 04ded1672402 ("RDMA/cma: Verify private data length")
Link: https://lore.kernel.org/r/1637661978-18770-1-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4037,8 +4037,7 @@ static int cma_resolve_ib_udp(struct rdm
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
-	req.private_data_len = offset + conn_param->private_data_len;
-	if (req.private_data_len < conn_param->private_data_len)
+	if (check_add_overflow(offset, conn_param->private_data_len, &req.private_data_len))
 		return -EINVAL;
 
 	if (req.private_data_len) {
@@ -4097,8 +4096,7 @@ static int cma_connect_ib(struct rdma_id
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
-	req.private_data_len = offset + conn_param->private_data_len;
-	if (req.private_data_len < conn_param->private_data_len)
+	if (check_add_overflow(offset, conn_param->private_data_len, &req.private_data_len))
 		return -EINVAL;
 
 	if (req.private_data_len) {


