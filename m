Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A806148B1
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiKAL3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKAL2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A1017E3A;
        Tue,  1 Nov 2022 04:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F52E615DC;
        Tue,  1 Nov 2022 11:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B55C433D6;
        Tue,  1 Nov 2022 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302083;
        bh=GqCyl68jp6W45Z7qyoiVK7tivUVx/lo83ju5sog/iCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVeWWfFuCPVehdvrg8KPLDxdIgMK6UHCkw1aMQ+2EmhL1wjhGZJmWD52MqoYRx/+f
         QRYC7WAx8pawY7yJgWfTX3IadUyI82yW2g0m4Db2OCMh1spnOfWEQ8tjUDyW3lHDWI
         2nkWWofA3gOv1CJ2HA5TUQs5rt+wrzQYUZ9XStu5GsGH/WndeEtHvHIvy4A+3zAkLt
         qGzDIWVgR3mAdQSAhNngyCAO4Au63ddopTnWMhiC80LTSyH2qJvAoZ4LEy9PsAu2Ok
         BFqxlyu7Ny2dNdXM7efDItYRKMNBgztxo1I7YlqFs8urcwDuv0T7UYr4+b+QXsbAtW
         UreXCb13Qgtyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        xiam0nd.tong@gmail.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 16/34] media: atomisp: Fix VIDIOC_TRY_FMT
Date:   Tue,  1 Nov 2022 07:27:08 -0400
Message-Id: <20221101112726.799368-16-sashal@kernel.org>
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
index c932f340068f..db6465756e49 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -4886,8 +4886,8 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_pix_format *f,
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

