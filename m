Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EF3548E1F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380968AbiFMOH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382269AbiFMOFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7F094184;
        Mon, 13 Jun 2022 04:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0220612A8;
        Mon, 13 Jun 2022 11:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7F5C34114;
        Mon, 13 Jun 2022 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120429;
        bh=HU1drH/HG1ZCFizUqiGDmW+GZ5VmIqZHoHG37lCZZCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDUe4pQd1EkMMCf3BROhhPSGxtd5G8uG2u4wbfDQ2+j7TfE/FkyxgdkvoB7SMxGuF
         oTJUOF/uUyRZ5uGprB+C/w7b6mO1BxuHR73Q/4OelWujK+Nx3gFWZD8RTdcjHcYQYy
         hBtpbPRgU2EXeOdOAIQrR9d1bS/3jwKediGJgl3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Hangyu Hua <hbh25y@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 029/298] rpmsg: virtio: Fix the unregistration of the device rpmsg_ctrl
Date:   Mon, 13 Jun 2022 12:08:43 +0200
Message-Id: <20220613094925.814570958@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

[ Upstream commit df191796985922488e4e6b64f7bd79c3934412f2 ]

Unregister the rpmsg_ctrl device instead of just freeing the
the virtio_rpmsg_channel structure.
This will properly unregister the device and call
virtio_rpmsg_release_device() that frees the structure.

Fixes: c486682ae1e2 ("rpmsg: virtio: Register the rpmsg_char device")
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Reviewed-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220426060536.15594-4-hbh25y@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 99e0de65733a..ed26e9226834 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -862,7 +862,7 @@ static void rpmsg_virtio_del_ctrl_dev(struct rpmsg_device *rpdev_ctrl)
 {
 	if (!rpdev_ctrl)
 		return;
-	kfree(to_virtio_rpmsg_channel(rpdev_ctrl));
+	device_unregister(&rpdev_ctrl->dev);
 }
 
 static int rpmsg_probe(struct virtio_device *vdev)
-- 
2.35.1



