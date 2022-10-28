Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57AB61109B
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiJ1MHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJ1MHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264D1867B6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8414B828C2
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EBCC433C1;
        Fri, 28 Oct 2022 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958828;
        bh=b4ISuiqGXlncQT1yYQwMUyp60yFi8/Ck80y/SVHhWY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/DWAlz067nwLM00aSuzY+5gJgURplRHKGhtOHxlDNzJVE/DTqRVqORCLYIRvBUDu
         AEvvZS27WRElnzBv3QTCXyIbAQSvGZdg12yN76ftdVlgj5NlEA8Dr6aZEwONlUtDil
         MHOnYTaiBylGQayKiVPF6MVBK/GwLo2jwbv/ofJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/73] nvme-hwmon: Return error code when registration fails
Date:   Fri, 28 Oct 2022 14:03:34 +0200
Message-Id: <20221028120233.990895711@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 78570f8873c8cd44c12714c7fa7db2601ec5617d ]

The hwmon pointer wont be NULL if the registration fails. Though the
exit code path will assign it to ctrl->hwmon_device. Later
nvme_hwmon_exit() will try to free the invalid pointer. Avoid this by
returning the error code from hwmon_device_register_with_info().

Fixes: ed7770f66286 ("nvme/hwmon: rework to avoid devm allocation")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: c94b7f9bab22 ("nvme-hwmon: kmalloc the NVME SMART log buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 8f9e96986780..0a586d712920 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -248,6 +248,7 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
 		kfree(data);
+		return PTR_ERR(hwmon);
 	}
 	ctrl->hwmon_device = hwmon;
 	return 0;
-- 
2.35.1



