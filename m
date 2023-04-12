Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0135A6DEEC2
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDLIo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDLIof (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1D66EA6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE01762A6E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E89C433EF;
        Wed, 12 Apr 2023 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289029;
        bh=e/Z5qEZh4IBJlMR5dxNup47f/gPo4jn7Mlhh01Ywrl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqTXDJ0g+RaXWStg6DVxsQfqI6ZoAZJmUtsS1/XeNDhP2WgGTFUf6g50UPK/UNKKb
         dZ4cf9slzerc5IHN+lR0QVWFYZehrVYVbmDi1iIX9ZSYHiMeeVQnIUTZaH4DLb+E8M
         olyHbGiD7ItXhTwUjHrAFwBcWGrwu6vQ80x3yX4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Breno Leitao <leitao@debian.org>
Subject: [PATCH 6.1 108/164] block: ublk: make sure that block size is set correctly
Date:   Wed, 12 Apr 2023 10:33:50 +0200
Message-Id: <20230412082841.211445011@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1d1665279a845d16c93687389e364386e3fe0f38 ]

block size is one very key setting for block layer, and bad block size
could panic kernel easily.

Make sure that block size is set correctly.

Meantime if ublk_validate_params() fails, clear ub->params so that disk
is prevented from being added.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reported-and-tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 22a790d512842..341f490fdbb02 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -233,7 +233,7 @@ static int ublk_validate_params(const struct ublk_device *ub)
 	if (ub->params.types & UBLK_PARAM_TYPE_BASIC) {
 		const struct ublk_param_basic *p = &ub->params.basic;
 
-		if (p->logical_bs_shift > PAGE_SHIFT)
+		if (p->logical_bs_shift > PAGE_SHIFT || p->logical_bs_shift < 9)
 			return -EINVAL;
 
 		if (p->logical_bs_shift > p->physical_bs_shift)
@@ -1886,6 +1886,8 @@ static int ublk_ctrl_set_params(struct io_uring_cmd *cmd)
 		/* clear all we don't support yet */
 		ub->params.types &= UBLK_PARAM_TYPE_ALL;
 		ret = ublk_validate_params(ub);
+		if (ret)
+			ub->params.types = 0;
 	}
 	mutex_unlock(&ub->mutex);
 	ublk_put_device(ub);
-- 
2.39.2



