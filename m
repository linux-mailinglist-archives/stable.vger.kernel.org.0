Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AEE615945
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKBDIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiKBDID (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:08:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00557240A3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5687617D2
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D277C433D6;
        Wed,  2 Nov 2022 03:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358438;
        bh=ACTQcOmK+A1lP9SX7Mm9UNVM2ERDbLXUbWK7749AcBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDtWHgMEpDp8kdGQ2BAuB/ovsslnrrsmIQusUjc1YZtIdUxPgqXkZEuOynI0bvfeG
         ohHM5FwkvtfLU9OYhoL1H/8s7ipyTaSvmsriQi0lYip3Dw3FcGBty9BmYdhJxRHNEc
         oEDl04gyF1S/UyhmSbi0YCZU6hE2GLhgXBSCE+mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/132] net: hinic: fix the issue of double release MBOX callback of VF
Date:   Wed,  2 Nov 2022 03:32:59 +0100
Message-Id: <20221102022101.526075609@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 8ec2f4c6b2e11a4249bba77460f0cfe6d95a82f8 ]

In hinic_vf_func_init(), if VF fails to register information with PF
through the MBOX, the MBOX callback function of VF is released once. But
it is released again in hinic_init_hwdev(). Remove one.

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index a78c398bf5b2..e81a7b28209b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1180,7 +1180,6 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 			dev_err(&hwdev->hwif->pdev->dev,
 				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
 				err, register_info.status, out_size);
-			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
 			return -EIO;
 		}
 	} else {
-- 
2.35.1



