Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4021E50558A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbiDRNOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241239AbiDRNLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EB82D1E5;
        Mon, 18 Apr 2022 05:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6565661254;
        Mon, 18 Apr 2022 12:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C2BC385A1;
        Mon, 18 Apr 2022 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286239;
        bh=H2E+hkoWrFyiw9Yw9enrsHb/6o1hrtPFBfEID+qRoMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9bsQ8i4+GuJEgh6CL6+ftOfmsbYjYS2an8Rwwh+7sByVMnmSxSirghWbsyGE2mmq
         +9N6bNcvjQ2TY14dDvloEOdsjUSIFv2xlazLb9ZRp8sAomH5zScBRNNh5ZKxuNy/pm
         M/BdhUWaVResTLQKnSjArFVJZDrcv/0LxpjPB3bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/284] media: coda: Fix missing put_device() call in coda_get_vdoa_data
Date:   Mon, 18 Apr 2022 14:10:52 +0200
Message-Id: <20220418121212.707431987@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ca85d271531a1e1c86f24b892f57b7d0a3ddb5a6 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: e7f3c5481035 ("[media] coda: use VDOA for un-tiling custom macroblock format")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 5b87c488ee11..993208944ace 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -360,6 +360,7 @@ static struct vdoa_data *coda_get_vdoa_data(void)
 	if (!vdoa_data)
 		vdoa_data = ERR_PTR(-EPROBE_DEFER);
 
+	put_device(&vdoa_pdev->dev);
 out:
 	if (vdoa_node)
 		of_node_put(vdoa_node);
-- 
2.34.1



