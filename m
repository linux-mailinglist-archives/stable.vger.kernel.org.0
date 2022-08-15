Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3D594850
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbiHOXch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353355AbiHOXbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ADD14F961;
        Mon, 15 Aug 2022 13:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86FF160DEB;
        Mon, 15 Aug 2022 20:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A72C433D7;
        Mon, 15 Aug 2022 20:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594089;
        bh=zfIZ+r3tJPCB2oToX0Vxr7pLYk/MjTYFsb8+1JVJSZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVjB2uwU7Aw6NOuAvpow9TQxNBKc6+D36x6Xk31UhnQcov7/7MhAqvYkwQ5Oga7Fc
         KiyorJkgLYa3MFj8z3/teij6+U4buqMhSxjvc2cxoHks0rSv+rwvmV202UvOpOkMmM
         fiRTS+wyUy5XFkllS3tLxMTKrcKXBY6Lci/OlPUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0372/1157] media: camss: csid: fix wrong size passed to devm_kmalloc_array()
Date:   Mon, 15 Aug 2022 19:55:28 +0200
Message-Id: <20220815180454.596391973@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4c25384d136642d72098e36201ca988533e73065 ]

'supplies' is a pointer, the real size of struct regulator_bulk_data
should be pass to devm_kmalloc_array().

Fixes: 0d8140179715 ("media: camss: Add regulator_bulk support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index f993f349b66b..80628801cf09 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -666,7 +666,7 @@ int msm_csid_subdev_init(struct camss *camss, struct csid_device *csid,
 	if (csid->num_supplies) {
 		csid->supplies = devm_kmalloc_array(camss->dev,
 						    csid->num_supplies,
-						    sizeof(csid->supplies),
+						    sizeof(*csid->supplies),
 						    GFP_KERNEL);
 		if (!csid->supplies)
 			return -ENOMEM;
-- 
2.35.1



