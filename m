Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7716AF09B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCGScc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCGScI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:32:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1125B372E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94DF0B818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAC9C433D2;
        Tue,  7 Mar 2023 18:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213482;
        bh=uku7f55HZfT5K/ElFyp6Oo42annPS+DyVI9Dya6RfWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1FdJiodnUC+farfN5JZdTHzyJvh0Z/d+1BqeD7kLR6HwwGY6MjxG5sRwYTl5/h9e
         u8BgEQJPx/a5HcexD8r71QxHAHus0qnaTQL+0NIzDNptGecmKntBuKGUQrlahPTfwH
         E+F0Dnd1hJY3oW573XinRthkpU0xJI8Gxbvn/8hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Shevchenko <andy@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 521/885] media: atomisp: Only set default_run_mode on first open of a stream/asd
Date:   Tue,  7 Mar 2023 17:57:35 +0100
Message-Id: <20230307170025.101806953@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 60ec70a71a9f9975a5d2dd4a7d97c20da0e41976 ]

Calling v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode) when
the stream is already active (through another /dev/video# node) causes
the stream to stop.

Move the call to set the default run-mode so that it is only done
on the first open of one of the 4 /dev/video# nodes of one of
the 2 streams (atomisp-sub-devices / asd-s).

Fixes: 2c45e343c581 ("media: atomisp: set per-device's default mode")
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 84a84e0cdeef7..5fa2e2596a818 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -741,13 +741,13 @@ static int atomisp_open(struct file *file)
 		goto done;
 
 	atomisp_subdev_init_struct(asd);
+	/* Ensure that a mode is set */
+	v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode);
 
 done:
 	pipe->users++;
 	mutex_unlock(&isp->mutex);
 
-	/* Ensure that a mode is set */
-	v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode);
 
 	return 0;
 
-- 
2.39.2



