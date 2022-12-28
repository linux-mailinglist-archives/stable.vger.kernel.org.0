Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5231657BAD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiL1PYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiL1PYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6119713E18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B96B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB0FC433D2;
        Wed, 28 Dec 2022 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241055;
        bh=cQTVHcqTfT/6Ds8nYR0bBv5qmdbUggzbQyTrhA1xnyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgGSnFX5XIBvWdi/I1shCDH6O5Xv8kKjpPNB38bES6QcEZ2MawyhrBkDp8AVjr9kD
         Fbws9o4SQ25/Z9daZSmcUuGMVxMYzblwWcqCniXuOUzBuqijt6GP+GNck2DgS6GCet
         br8x3YtotPRdeP61K/5Z/78V3hb2lE2X/ypG8+GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/731] RDMA/hns: Fix error code of CMD
Date:   Wed, 28 Dec 2022 15:38:59 +0100
Message-Id: <20221228144309.085857836@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 667d6164b84884c64de3fc18670cd5a98b0b10cf ]

The error code is fixed to EIO when CMD fails to excute. This patch
converts the error status reported by firmware to linux errno.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Link: https://lore.kernel.org/r/20221126102911.2921820-6-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 26 +++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  5 +++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 16f39321b319..79d92b789984 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1257,6 +1257,30 @@ static void update_cmdq_status(struct hns_roce_dev *hr_dev)
 		hr_dev->cmd.state = HNS_ROCE_CMDQ_STATE_FATAL_ERR;
 }
 
+static int hns_roce_cmd_err_convert_errno(u16 desc_ret)
+{
+	struct hns_roce_cmd_errcode errcode_table[] = {
+		{CMD_EXEC_SUCCESS, 0},
+		{CMD_NO_AUTH, -EPERM},
+		{CMD_NOT_EXIST, -EOPNOTSUPP},
+		{CMD_CRQ_FULL, -EXFULL},
+		{CMD_NEXT_ERR, -ENOSR},
+		{CMD_NOT_EXEC, -ENOTBLK},
+		{CMD_PARA_ERR, -EINVAL},
+		{CMD_RESULT_ERR, -ERANGE},
+		{CMD_TIMEOUT, -ETIME},
+		{CMD_HILINK_ERR, -ENOLINK},
+		{CMD_INFO_ILLEGAL, -ENXIO},
+		{CMD_INVALID, -EBADR},
+	};
+	u16 i;
+
+	for (i = 0; i < ARRAY_SIZE(errcode_table); i++)
+		if (desc_ret == errcode_table[i].return_status)
+			return errcode_table[i].errno;
+	return -EIO;
+}
+
 static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_cmq_desc *desc, int num)
 {
@@ -1301,7 +1325,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			dev_err_ratelimited(hr_dev->dev,
 					    "Cmdq IO error, opcode = %x, return = %x\n",
 					    desc->opcode, desc_ret);
-			ret = -EIO;
+			ret = hns_roce_cmd_err_convert_errno(desc_ret);
 		}
 	} else {
 		/* FW/HW reset or incorrect number of desc */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2f4a0019a716..67f5b6fcfa1b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -276,6 +276,11 @@ enum hns_roce_cmd_return_status {
 	CMD_OTHER_ERR = 0xff
 };
 
+struct hns_roce_cmd_errcode {
+	enum hns_roce_cmd_return_status return_status;
+	int errno;
+};
+
 enum hns_roce_sgid_type {
 	GID_TYPE_FLAG_ROCE_V1 = 0,
 	GID_TYPE_FLAG_ROCE_V2_IPV4,
-- 
2.35.1



