Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCE5939D6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbiHOT2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344645AbiHOT1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71F95A3CA;
        Mon, 15 Aug 2022 11:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34656B810A2;
        Mon, 15 Aug 2022 18:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD8EC433D6;
        Mon, 15 Aug 2022 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588970;
        bh=kqisEMR1dw40SEAe95IXg/m0xgPf6Z1t4GvyGIxY2Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xu7Gb1N8l6dFWTvcbynATkdbttLyU1SlTDRgi8H/t7Ri+qTWT7C67gM90TCcr+kB
         lBCUvJCVEycWpeyENIO+AduaSbaHm4XMiFRREMdLfxKVRup6yLutVE0TTKvibjibtg
         nADPVLrtt4DIFXQQdTu8Y8hOwj7HNffA1uypIfOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 573/779] rpmsg: char: Add mutex protection for rpmsg_eptdev_open()
Date:   Mon, 15 Aug 2022 20:03:37 +0200
Message-Id: <20220815180401.816997752@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit abe13e9a561d6b3e82b21362c0d6dd3ecd8a5b13 ]

There is no mutex protection for rpmsg_eptdev_open(),
especially for eptdev->ept read and write operation.
It may cause issues when multiple instances call
rpmsg_eptdev_open() in parallel,the return state
may be success or EBUSY.

Fixes: 964e8bedd5a1 ("rpmsg: char: Return an error if device already open")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1653104105-16779-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/rpmsg_char.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index 49dd5a200998..88c985f9e73a 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -127,8 +127,11 @@ static int rpmsg_eptdev_open(struct inode *inode, struct file *filp)
 	struct rpmsg_device *rpdev = eptdev->rpdev;
 	struct device *dev = &eptdev->dev;
 
-	if (eptdev->ept)
+	mutex_lock(&eptdev->ept_lock);
+	if (eptdev->ept) {
+		mutex_unlock(&eptdev->ept_lock);
 		return -EBUSY;
+	}
 
 	get_device(dev);
 
@@ -136,11 +139,13 @@ static int rpmsg_eptdev_open(struct inode *inode, struct file *filp)
 	if (!ept) {
 		dev_err(dev, "failed to open %s\n", eptdev->chinfo.name);
 		put_device(dev);
+		mutex_unlock(&eptdev->ept_lock);
 		return -EINVAL;
 	}
 
 	eptdev->ept = ept;
 	filp->private_data = eptdev;
+	mutex_unlock(&eptdev->ept_lock);
 
 	return 0;
 }
-- 
2.35.1



