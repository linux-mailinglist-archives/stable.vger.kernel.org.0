Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E446675CF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbjALOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjALOYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:24:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2958C5B4B5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2FCDDCE1E73
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8CAC433D2;
        Thu, 12 Jan 2023 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532990;
        bh=mrd5m7P6C2T5K5whYgn0Jrdnb/gYAhLOG8cMb481ymI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghanrZYwrzh5gKBZ5aJmatFUBkN/S0AaYhpz6OlcFzDNrdk43CUp3Ay/6n2qESamH
         j+w+hu2DAThAXZ8Oks5OZoIHkAOnIavyMgWKYjygLWvELB0+t4FJ56hE0KqgAEP4mj
         3CBBauJRAPGlCaeA/Xwid9cQOmlb/SXmfSxsfr84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/783] RDMA/srp: Fix error return code in srp_parse_options()
Date:   Thu, 12 Jan 2023 14:50:49 +0100
Message-Id: <20230112135539.736563979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index b4ccb333a834..adbd56af379f 100644
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



