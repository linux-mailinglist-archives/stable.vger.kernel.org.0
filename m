Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF533603E77
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiJSJP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiJSJN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C590823;
        Wed, 19 Oct 2022 02:03:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A22B61750;
        Wed, 19 Oct 2022 09:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0535DC433D6;
        Wed, 19 Oct 2022 09:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170164;
        bh=8jvjNDiaCdUPJjeCJK4JOqJEZvEbt3GWCTDXTZfvlps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoRHaa9d+kM/gv1CffIJvtcCzBVewU/cEfMMkrsT7kl+o+IQiP7ytBwgDoi3F+06b
         zWRaTnSeTKHI06aCT7ufVAcxkwh7vB/EIqhXd50fENjejOFCJQQ/iCZClZYHwTR0AN
         0PEzKzoINSAn0jy+HmCJJ17vYcJP4zvQXD46CmUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <Guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 550/862] md: Remove extra mddev_get() in md_seq_start()
Date:   Wed, 19 Oct 2022 10:30:37 +0200
Message-Id: <20221019083314.271924843@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 3bfc3bcd787c48aa31e4fde4a6dfcef4cd7ee2c2 ]

A regression is seen where mddev devices stay permanently after they
are stopped due to an elevated reference count.

This was tracked down to an extra mddev_get() in md_seq_start().

It only happened rarely because most of the time the md_seq_start()
is called with a zero offset. The path with an extra mddev_get() only
happens when it starts with a non-zero offset.

The commit noted below changed an mddev_get() to check its success
but inadvertently left the original call in. Remove the extra call.

Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Guoqing Jiang <Guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 729be2c5296c..470a975e4be9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8156,7 +8156,6 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 	list_for_each(tmp,&all_mddevs)
 		if (!l--) {
 			mddev = list_entry(tmp, struct mddev, all_mddevs);
-			mddev_get(mddev);
 			if (!mddev_get(mddev))
 				continue;
 			spin_unlock(&all_mddevs_lock);
-- 
2.35.1



