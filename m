Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71856159A9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKBDQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKBDPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:15:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DC624BEF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDC0B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76002C433C1;
        Wed,  2 Nov 2022 03:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358934;
        bh=4zCCEprtMmqynw5l30ROvAT4mXd1UaHS/SC7WUkiGwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqBCjO0k98sn2Z41WdBSoA0JkwsV525AVwaFluy8eZftW94I2EzrzACaEuYG1Qt3Q
         XvicZDLva4sP53AqLJYrxBjlzUwI2Rym94OM3tWTTfYUSW5OKurnUNkdLOvOKnlX5z
         vec+Vmiv9kFuFSD/UR5EyfRxTEaBY+q8Q/efoxM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/91] net: hinic: fix the issue of double release MBOX callback of VF
Date:   Wed,  2 Nov 2022 03:33:32 +0100
Message-Id: <20221102022056.416823495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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
index f8a26459ff65..4d82ebfe27f9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1178,7 +1178,6 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 			dev_err(&hwdev->hwif->pdev->dev,
 				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
 				err, register_info.status, out_size);
-			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
 			return -EIO;
 		}
 	} else {
-- 
2.35.1



