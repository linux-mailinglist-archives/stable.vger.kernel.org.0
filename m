Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E08657B95
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiL1PX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiL1PXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FCB13E18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D294B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDA2C433D2;
        Wed, 28 Dec 2022 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240994;
        bh=MGeFGa+t+de0D4N0m5cs3jCD0iHHSXGXUzRPsSh/mYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCdfU6ERDxzJx7SOGTLw3PYUjpio7Q6nsujMeT+Dd9h1REHcpgo/LGyNcZA5bcLKM
         DRkS2NdnlbWpxgXhVcQLv0f3M5l4UFCtxszFfoCuPlh0/Z/eGWjl6ekgr7qR9hvCsz
         heMdl2jbFZV6sN+pf2Eb1nNefXMBWJQgXX4ZIxR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/731] RDMA/srp: Fix error return code in srp_parse_options()
Date:   Wed, 28 Dec 2022 15:38:52 +0100
Message-Id: <20221228144308.886921594@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit ed461b30b22c8fa85c25189c14cb89f29595cd14 ]

In the previous iteration of the while loop, the "ret" may have been
assigned a value of 0, so the error return code -EINVAL may have been
incorrectly set to 0. To fix set valid return code before calling to
goto. Also investigate each case separately as Andy suggessted.

Fixes: e711f968c49c ("IB/srp: replace custom implementation of hex2bin()")
Fixes: 2a174df0c602 ("IB/srp: Use kstrtoull() instead of simple_strtoull()")
Fixes: 19f313438c77 ("IB/srp: Add RDMA/CM support")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1669953638-11747-2-git-send-email-wangyufen@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 96 ++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2f4991cea98c..a6117a7d0ab1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3397,7 +3397,8 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_PKEY:
-			if (match_hex(args, &token)) {
+			ret = match_hex(args, &token);
+			if (ret) {
 				pr_warn("bad P_Key parameter '%s'\n", p);
 				goto out;
 			}
@@ -3457,7 +3458,8 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_MAX_SECT:
-			if (match_int(args, &token)) {
+			ret = match_int(args, &token);
+			if (ret) {
 				pr_warn("bad max sect parameter '%s'\n", p);
 				goto out;
 			}
@@ -3465,8 +3467,15 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_QUEUE_SIZE:
-			if (match_int(args, &token) || token < 1) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for queue_size parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1) {
 				pr_warn("bad queue_size parameter '%s'\n", p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->scsi_host->can_queue = token;
@@ -3477,25 +3486,40 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_MAX_CMD_PER_LUN:
-			if (match_int(args, &token) || token < 1) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for max cmd_per_lun parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1) {
 				pr_warn("bad max cmd_per_lun parameter '%s'\n",
 					p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->scsi_host->cmd_per_lun = token;
 			break;
 
 		case SRP_OPT_TARGET_CAN_QUEUE:
-			if (match_int(args, &token) || token < 1) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for max target_can_queue parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1) {
 				pr_warn("bad max target_can_queue parameter '%s'\n",
 					p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->target_can_queue = token;
 			break;
 
 		case SRP_OPT_IO_CLASS:
-			if (match_hex(args, &token)) {
+			ret = match_hex(args, &token);
+			if (ret) {
 				pr_warn("bad IO class parameter '%s'\n", p);
 				goto out;
 			}
@@ -3504,6 +3528,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 				pr_warn("unknown IO class parameter value %x specified (use %x or %x).\n",
 					token, SRP_REV10_IB_IO_CLASS,
 					SRP_REV16A_IB_IO_CLASS);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->io_class = token;
@@ -3526,16 +3551,24 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_CMD_SG_ENTRIES:
-			if (match_int(args, &token) || token < 1 || token > 255) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for max cmd_sg_entries parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1 || token > 255) {
 				pr_warn("bad max cmd_sg_entries parameter '%s'\n",
 					p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->cmd_sg_cnt = token;
 			break;
 
 		case SRP_OPT_ALLOW_EXT_SG:
-			if (match_int(args, &token)) {
+			ret = match_int(args, &token);
+			if (ret) {
 				pr_warn("bad allow_ext_sg parameter '%s'\n", p);
 				goto out;
 			}
@@ -3543,43 +3576,77 @@ static int srp_parse_options(struct net *net, const char *buf,
 			break;
 
 		case SRP_OPT_SG_TABLESIZE:
-			if (match_int(args, &token) || token < 1 ||
-					token > SG_MAX_SEGMENTS) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for max sg_tablesize parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1 || token > SG_MAX_SEGMENTS) {
 				pr_warn("bad max sg_tablesize parameter '%s'\n",
 					p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->sg_tablesize = token;
 			break;
 
 		case SRP_OPT_COMP_VECTOR:
-			if (match_int(args, &token) || token < 0) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for comp_vector parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 0) {
 				pr_warn("bad comp_vector parameter '%s'\n", p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->comp_vector = token;
 			break;
 
 		case SRP_OPT_TL_RETRY_COUNT:
-			if (match_int(args, &token) || token < 2 || token > 7) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for tl_retry_count parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 2 || token > 7) {
 				pr_warn("bad tl_retry_count parameter '%s' (must be a number between 2 and 7)\n",
 					p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->tl_retry_count = token;
 			break;
 
 		case SRP_OPT_MAX_IT_IU_SIZE:
-			if (match_int(args, &token) || token < 0) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for max it_iu_size parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 0) {
 				pr_warn("bad maximum initiator to target IU size '%s'\n", p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->max_it_iu_size = token;
 			break;
 
 		case SRP_OPT_CH_COUNT:
-			if (match_int(args, &token) || token < 1) {
+			ret = match_int(args, &token);
+			if (ret) {
+				pr_warn("match_int() failed for channel count parameter '%s', Error %d\n",
+					p, ret);
+				goto out;
+			}
+			if (token < 1) {
 				pr_warn("bad channel count %s\n", p);
+				ret = -EINVAL;
 				goto out;
 			}
 			target->ch_count = token;
@@ -3588,6 +3655,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 		default:
 			pr_warn("unknown parameter or missing value '%s' in target creation request\n",
 				p);
+			ret = -EINVAL;
 			goto out;
 		}
 	}
-- 
2.35.1



