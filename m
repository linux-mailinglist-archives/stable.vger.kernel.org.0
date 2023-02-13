Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03736949B6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjBMPBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjBMPBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:01:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBA435BA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D73B80E62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F7EC433EF;
        Mon, 13 Feb 2023 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300443;
        bh=4BizzojASlfOMfPjScXM/hYSaz2EJZCUfLR3NHts/Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBLFRy4XzDw8rcHa1lwwjK6WlDEvWUhwYBV+NR2xKybnINXyFT0t3CEu/6vRZaOjy
         G/42AsYJ0wXvoztrpcREF2TZyBeY4V+p9nOq93oON1KXOsP+RIKrjTZR7F10SL2v2n
         ubC1i2GpQgz0mpO9lFfe1pAcWyCAmo9gdvMKjtwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/139] READ is "data destination", not source...
Date:   Mon, 13 Feb 2023 15:49:22 +0100
Message-Id: <20230213144746.567877354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 355d2c2798e9dc39f6714fa7ef8902c0d4c5350b ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5c39e4c4bef7..1a5805260778 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -902,7 +902,7 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 	req->need_inv_comp = false;
 	req->inv_errno = 0;
 
-	iov_iter_kvec(&iter, READ, vec, 1, usr_len);
+	iov_iter_kvec(&iter, WRITE, vec, 1, usr_len);
 	len = _copy_from_iter(req->iu->buf, usr_len, &iter);
 	WARN_ON(len != usr_len);
 
-- 
2.39.0



