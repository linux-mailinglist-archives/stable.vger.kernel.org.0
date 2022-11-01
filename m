Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1075A6148A0
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiKAL2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKAL2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D51A238;
        Tue,  1 Nov 2022 04:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41F36615D8;
        Tue,  1 Nov 2022 11:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87A2C433D6;
        Tue,  1 Nov 2022 11:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302079;
        bh=ny54Y6RUGC4IhFUZ4LUspzh7kDc7wWblm4DkM9brLsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqbDTRmv/zKxsNJH4y4qCWGecs1rK868oMuJJkpyVFFjLSBxhsvjoQdLLuvMa5vrQ
         Zop00gPfKbFpy5VCi96MzhPpzUqhChzBv3/6uVH4Jza9k+qlxisM3oo99qMPE6Tsi4
         mXw3PiaSl2mIlZJfxIWPEqi9Yg86VWl2/Sr4zCsb0Otw8AqF7VPeWi9NKNjhH+YyIC
         bMdff9sKOd+8FORgKmzNZoojpRcych8GPOm8ARbbbkm+e+l2+uoKe1vGJ7kCTnBcdk
         QnbQ+I7D/umycstWAb4Yi9/ZUK2NKrivqb1ik8qftiIRiFENHMXn7UH4386335N8jB
         z3ZdNkn+wTcXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 15/34] media: atomisp-ov2680: Fix ov2680_set_fmt()
Date:   Tue,  1 Nov 2022 07:27:07 -0400
Message-Id: <20221101112726.799368-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit adea153b4f6537f367fe77abada263fde8a1f7b6 ]

On sets actually store the set (closest) format inside ov2680_device.dev,
so that it also properly gets returned by get_fmt.

This fixes the following problem:

1. App does an VIDIOC_SET_FMT 640x480, calling ov2680_set_fmt()
2. Internal buffers (atomisp_create_pipes_stream()) get allocated
   at 640x480 size by atomisp_set_fmt()
3. ov2680_get_fmt() gets called later on and returns 1600x1200
   since ov2680_device.dev was not updated. So things get configured
   to stream at 1600x1200, but the internal buffers created during
   atomisp_create_pipes_stream() do not get updated in size
4. streaming starts, internal buffers overflow and the entire
   machine freezes eventually due to memory being corrupted

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index 4ba99c660681..ab52e35266bb 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -894,11 +894,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	if (v_flag)
 		ov2680_v_flip(sd, v_flag);
 
-	/*
-	 * ret = startup(sd);
-	 * if (ret)
-	 * dev_err(&client->dev, "ov2680 startup err\n");
-	 */
+	dev->res = res;
 err:
 	mutex_unlock(&dev->input_lock);
 	return ret;
-- 
2.35.1

