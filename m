Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B941501153
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245158AbiDNNr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbiDNNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE4893189;
        Thu, 14 Apr 2022 06:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12C861D29;
        Thu, 14 Apr 2022 13:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2F8C385A5;
        Thu, 14 Apr 2022 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943323;
        bh=XS+IbrG0j3DZS5xyepIIdLvBWKhipwwYz91ray5Y8ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygfunR2a1aqvCYEXsU82lvP8PubU617dO4VDC7LtNFKZZilmyALNNx+TL0bZSUkBI
         n8TBlIOcnqePb19QyPTzZsaRpVx2jowEnslY7GYsa3rfhAEWVedDSBDjsv/TRkLhSU
         ArMJyEXDJinYrAc/epKr/Rdo18nwf45ejK4UOCrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/475] media: coda: Fix missing put_device() call in coda_get_vdoa_data
Date:   Thu, 14 Apr 2022 15:08:19 +0200
Message-Id: <20220414110858.342775720@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 834f11fe9dc2..0adc54832657 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -372,6 +372,7 @@ static struct vdoa_data *coda_get_vdoa_data(void)
 	if (!vdoa_data)
 		vdoa_data = ERR_PTR(-EPROBE_DEFER);
 
+	put_device(&vdoa_pdev->dev);
 out:
 	of_node_put(vdoa_node);
 
-- 
2.34.1



