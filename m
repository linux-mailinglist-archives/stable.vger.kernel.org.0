Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106994F3C4A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiDEMHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356969AbiDEKZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F63C4E2D;
        Tue,  5 Apr 2022 03:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 636246179C;
        Tue,  5 Apr 2022 10:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503B9C385A0;
        Tue,  5 Apr 2022 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153358;
        bh=Z7mrj6JD5q7BUmziq5k5KH5tmvw4CIe8WpOS8nmYG7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=es0DTJBcJgF58ZkP588AYFIFMJZ3Z/TlqZbXHVe/M3le++tmlHVi5d6srrBDnnqT+
         iyZW1XAC6rSt1Y9SLnJDLnaZJZlI5io8whTy1JW6BexV0t5ZrhXAdoR3wWcJwnnN+/
         NpKaTeoOlXVfVEwmnApFhkN6yD0/jWDldnMv5YEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/599] media: coda: Fix missing put_device() call in coda_get_vdoa_data
Date:   Tue,  5 Apr 2022 09:28:07 +0200
Message-Id: <20220405070304.584708385@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 1eed69d29149..2333079a83c7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -408,6 +408,7 @@ static struct vdoa_data *coda_get_vdoa_data(void)
 	if (!vdoa_data)
 		vdoa_data = ERR_PTR(-EPROBE_DEFER);
 
+	put_device(&vdoa_pdev->dev);
 out:
 	of_node_put(vdoa_node);
 
-- 
2.34.1



