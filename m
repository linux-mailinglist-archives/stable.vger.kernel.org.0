Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A2D614907
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKALcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiKALbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1CB6272;
        Tue,  1 Nov 2022 04:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E094B81CCD;
        Tue,  1 Nov 2022 11:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCF3C433D7;
        Tue,  1 Nov 2022 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302181;
        bh=mtvIqByc8Rdd2/mRDnbj49o/KRB4x/fx4l3cwiFNA5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DU6PsyoReeUtePswYmMUOIbIXO9q3F/fJaP1+0bfZyW8DA1aeqo8V/n2aqXfHWeHs
         76QTtIKOvtI9iU6U7lv4tEP/D74UZKKugaGzKCzTa1xkIJAX3UCGOriacIw2KlXukG
         PvK07v3FJ5N8MzscEcEIL4YpxXiPLuvT1bZ/ThEd7bDi8au5DW3uKvYiQypuktgc7/
         2/rmLg6CjK9uL8xIyNEnG1yjXEEoOgmZIxoo5epZWjpm4nzEBbdhNHc8K2x4954Kjb
         ciXju8tho1Qjy66uvaGHwBCWyP4mxahYdw+CT1YtLtiFcNBb1n+JuNt6pxWEiEMyuL
         6OCC5K4ArFXvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        xiam0nd.tong@gmail.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 10/19] media: atomisp: Fix VIDIOC_TRY_FMT
Date:   Tue,  1 Nov 2022 07:29:10 -0400
Message-Id: <20221101112919.799868-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
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

[ Upstream commit 4d3aafb9c9bba59c9b6f6df8ea6c89483bfed8d4 ]

atomisp_try_fmt() calls the sensor's try_fmt handler but it does
not copy the result back to the passed in v4l2_pix_format under
some circumstances.

Potentially returning an unsupported resolution to userspace,
which VIDIOC_TRY_FMT is not supposed to do.

atomisp_set_fmt() also uses atomisp_try_fmt() and relies
on this wrong behavior. The VIDIOC_TRY_FMT call passes NULL for
the res_overflow argument where as the atomisp_set_fmt() call
passes non NULL.

Use the res_overflow argument to differentiate between the 2 callers
and always propagate the sensors result in the VIDIOC_TRY_FMT case.

This fixes the resolution list in camorama showing resolutions like e.g.
1584x1184 instead of 1600x1200.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 88db9818e083..1c36e0108b1d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -4954,8 +4954,8 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_pix_format *f,
 		return 0;
 	}
 
-	if (snr_mbus_fmt->width < f->width
-	    && snr_mbus_fmt->height < f->height) {
+	if (!res_overflow || (snr_mbus_fmt->width < f->width &&
+			      snr_mbus_fmt->height < f->height)) {
 		f->width = snr_mbus_fmt->width;
 		f->height = snr_mbus_fmt->height;
 		/* Set the flag when resolution requested is
-- 
2.35.1

