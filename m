Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F133259D942
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348876AbiHWJRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349601AbiHWJQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A267539B;
        Tue, 23 Aug 2022 01:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25184614C2;
        Tue, 23 Aug 2022 08:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5E6C43140;
        Tue, 23 Aug 2022 08:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243548;
        bh=gm4JWmFIYfwLgfO8bC1MN2J9LdWEiHeJg2NX56k84FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XU4tSjREz96PFMwsO6RSfe5Dm2mcG5Z7QYGBf4s38+zzriYPlbW8eHUx3wiDDxaFV
         t1FuK19dpj0nFC1AESNDe/78VBha6gx7yUVqkMnbiu36+NPOTj5kkjP7QyyPRh/wF4
         FUPnjtq96XhmSAAXNcVCUpnwmKjaaS8pLn5yZEPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 312/365] md/raid5: Make logic blocking check consistent with logic that blocks
Date:   Tue, 23 Aug 2022 10:03:33 +0200
Message-Id: <20220823080131.232792593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 6e3f50d30af847bebce072182bd735e90a294c6a ]

The check in raid5_make_request differs very slightly from the logic
that causes it to block lower down. This likely does not cause a bug
as the check is fuzzy anyway (as reshape may move on between the first
check and the subsequent check). However, make it consistent so it can
be cleaned up in a subsequent patch.

The condition which causes the schedule is:

 !(mddev->reshape_backwards ? logical_sector < conf->reshape_progress :
   logical_sector >= conf->reshape_progress) &&
  (mddev->reshape_backwards ? logical_sector < conf->reshape_safe :
   logical_sector >= conf->reshape_safe)

The condition that causes the early bailout is made to match this.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c8539d0e12dd..45482cebacdb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5841,7 +5841,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	if ((bi->bi_opf & REQ_NOWAIT) &&
 	    (conf->reshape_progress != MaxSector) &&
 	    (mddev->reshape_backwards
-	    ? (logical_sector > conf->reshape_progress && logical_sector <= conf->reshape_safe)
+	    ? (logical_sector >= conf->reshape_progress && logical_sector < conf->reshape_safe)
 	    : (logical_sector >= conf->reshape_safe && logical_sector < conf->reshape_progress))) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
-- 
2.35.1



