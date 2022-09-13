Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45C35B706A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiIMO1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiIMO0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:26:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEF36565F;
        Tue, 13 Sep 2022 07:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B56DCE1278;
        Tue, 13 Sep 2022 14:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7345BC433D7;
        Tue, 13 Sep 2022 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078491;
        bh=UbCpuCPbcinXMCZOspcJy2W/PDBVglLjkQGxbqYYNsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnp50GIMahQAtX13Ipbw9G/q4F9+ju7cri3tyL16R8ZhXQ8TZYN7UpPflt3tqglUZ
         S5aMVe45ovcDJphmmPyCPZnIC9Z4gu0guYZC/drN3UxfuM5Nmq1hQJUMU49UUEqgK2
         9B9iIXQ60n++OXyA7zSn8e6v2cWuAsfOi0uGL6ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 135/192] nvme-tcp: fix UAF when detecting digest errors
Date:   Tue, 13 Sep 2022 16:04:01 +0200
Message-Id: <20220913140416.739412712@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 160f3549a907a50e51a8518678ba2dcf2541abea ]

We should also bail from the io_work loop when we set rd_enabled to true,
so we don't attempt to read data from the socket when the TCP stream is
already out-of-sync or corrupted.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7a9e6ffa23429..40bd68ba1040a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1227,7 +1227,7 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		else if (unlikely(result < 0))
 			return;
 
-		if (!pending)
+		if (!pending || !queue->rd_enabled)
 			return;
 
 	} while (!time_after(jiffies, deadline)); /* quota is exhausted */
-- 
2.35.1



