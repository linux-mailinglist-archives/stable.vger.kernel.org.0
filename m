Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A01677021
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjAVP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjAVP2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:28:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0276C14EAE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F4960C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E95C433EF;
        Sun, 22 Jan 2023 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401330;
        bh=9LcJTYZi/AcWsA4gzinWjoOzlxrR98QQqPTYJ8P9Eco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6pFc3iBsjKVmH6QMDOa9/kmdi4CYj1uEn/7GZlFevd2/xK5npXT+crcfCv4uvJxA
         CiFezKwas9RV7jrZp4myRJ79SW2cYxpLOr6RQJPa9FpwnWvGcUbjx0L/HIikJz4dpm
         gSvqFVTxgJKPIJb9xK2UAh4NzrTELu/DdlulV5/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 190/193] net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()
Date:   Sun, 22 Jan 2023 16:05:19 +0100
Message-Id: <20230122150255.097162155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 90e7cb78b81543998217b0eb446c067ce2191a79 upstream.

Add missing mutex_unlock() before returning from
mlx5_fw_fatal_reporter_err_work().

Fixes: 9078e843efec ("net/mlx5: Avoid recovery in probe flows")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -677,6 +677,7 @@ static void mlx5_fw_fatal_reporter_err_w
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
 	mutex_unlock(&dev->intf_state_mutex);


