Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35488521926
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243666AbiEJNoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244408AbiEJNly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:41:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8572A18A8;
        Tue, 10 May 2022 06:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B656B81DA9;
        Tue, 10 May 2022 13:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D55C385A6;
        Tue, 10 May 2022 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189380;
        bh=7b45LitcIjr6BPZ5gQ51jLVH7r1C99pleqPuIU4VhD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFa6WME9xDHpMfY7m5dCk1zmdgfzpxNMdFXPbK7mISsnE2mfkU2Qa6aCRHGtR8A/k
         SAlyqmMYSY+nm4WCkAyzppKaNUa8MYxrI8/KGOtau1uOmbkYodz6dYjViGyZJYbmm2
         vhcHPNi4HtXk+04w2wQmgqdLR3gjdvbdXqK+FKGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 031/135] s390/dasd: Fix read inconsistency for ESE DASD devices
Date:   Tue, 10 May 2022 15:06:53 +0200
Message-Id: <20220510130741.294562511@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

commit b9c10f68e23c13f56685559a0d6fdaca9f838324 upstream.

Read requests that return with NRF error are partially completed in
dasd_eckd_ese_read(). The function keeps track of the amount of
processed bytes and the driver will eventually return this information
back to the block layer for further processing via __dasd_cleanup_cqr()
when the request is in the final stage of processing (from the driver's
perspective).

For this, blk_update_request() is used which requires the number of
bytes to complete the request. As per documentation the nr_bytes
parameter is described as follows:
   "number of bytes to complete for @req".

This was mistakenly interpreted as "number of bytes _left_ for @req"
leading to new requests with incorrect data length. The consequence are
inconsistent and completely wrong read requests as data from random
memory areas are read back.

Fix this by correctly specifying the amount of bytes that should be used
to complete the request.

Fixes: 5e6bdd37c552 ("s390/dasd: fix data corruption for thin provisioned devices")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20220505141733.1989450-5-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2775,8 +2775,7 @@ static void __dasd_cleanup_cqr(struct da
 		 * complete a request partially.
 		 */
 		if (proc_bytes) {
-			blk_update_request(req, BLK_STS_OK,
-					   blk_rq_bytes(req) - proc_bytes);
+			blk_update_request(req, BLK_STS_OK, proc_bytes);
 			blk_mq_requeue_request(req, true);
 		} else if (likely(!blk_should_fake_timeout(req->q))) {
 			blk_mq_complete_request(req);


