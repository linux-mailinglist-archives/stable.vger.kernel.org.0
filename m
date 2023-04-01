Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE656D2CB4
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjDABmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjDABmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF65A20DA6;
        Fri, 31 Mar 2023 18:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03F062CE1;
        Sat,  1 Apr 2023 01:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6D4C433D2;
        Sat,  1 Apr 2023 01:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313308;
        bh=XirnIgZ9S0tSEoZVOZ9ZU/c4xaqjAjSCS8VJZDEoJk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdQj5SwsPaU2qEvTy+KS6TOUAwj7B4+cl1J/bpgyeBp4Lfpt6y0RcgV5EwUVoSN8Z
         1nYFrxLM5LyUiHYQkhLSHowMShFaeXWTLCPU0r4uo1ZKAVltgudX2e/JtmXV3l+aIS
         Tin3LnA8W/4A48G7J9uXfEMHsnI3g9trFbh0wlTYtIONeaP5ShM1m1mEezV1sCmh66
         fekQwDqxRn7U+LDKFv2Zi/7lU5JLgTqdGhSZgEI03ms7Jx8l3INeZKzF8qY5oQG8Vk
         OqT2j7OLRrE9WsCfpPGz374G3fBrYznPyhLqa20r4vcL7vJcbWL1Nmr9eCF1rKZm+I
         HENkahlAyZJEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 12/25] block: ublk_drv: mark device as LIVE before adding disk
Date:   Fri, 31 Mar 2023 21:41:10 -0400
Message-Id: <20230401014126.3356410-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4985e7b2c002eb4c5c794a1d3acd91b82c89a0fd ]

IO can be started before add_disk() returns, such as reading parititon table,
then the monitor work should work for making forward progress.

So mark device as LIVE before adding disk, meantime change to
DEAD if add_disk() fails.

Fixed: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230318141231.55562-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 22a790d512842..f24d47d349256 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1553,17 +1553,18 @@ static int ublk_ctrl_start_dev(struct io_uring_cmd *cmd)
 		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	get_device(&ub->cdev_dev);
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	ret = add_disk(disk);
 	if (ret) {
 		/*
 		 * Has to drop the reference since ->free_disk won't be
 		 * called in case of add_disk failure.
 		 */
+		ub->dev_info.state = UBLK_S_DEV_DEAD;
 		ublk_put_device(ub);
 		goto out_put_disk;
 	}
 	set_bit(UB_STATE_USED, &ub->state);
-	ub->dev_info.state = UBLK_S_DEV_LIVE;
 out_put_disk:
 	if (ret)
 		put_disk(disk);
-- 
2.39.2

