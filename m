Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77B531634
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiEWRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239982AbiEWRSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781686B66B;
        Mon, 23 May 2022 10:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F86C60AB8;
        Mon, 23 May 2022 17:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E725C385AA;
        Mon, 23 May 2022 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326207;
        bh=s/wM9yw1sAuIFJAp3+xxsTnu7j5+IlJj2gurHg09ouM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cam8vyqqkOCJV493SkGG2hbUjjduymzfXxrIW6euYSOfHbwbsCl22jMYQp/p7BHSt
         9cBVrqSCGJ9ZK3begpt2cAMGxIGQMfCGqDe7X8iwVAZda04j6U2wtlfN9HoruRGxAa
         QHGAVYUcgjx4toVx9z71bavJd9OOEfY6g7a/zlMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/97] vhost_vdpa: dont setup irq offloading when irq_num < 0
Date:   Mon, 23 May 2022 19:05:24 +0200
Message-Id: <20220523165815.482489476@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

[ Upstream commit cce0ab2b2a39072d81f98017f7b076f3410ef740 ]

When irq number is negative(e.g., -EINVAL), the virtqueue
may be disabled or the virtqueues are sharing a device irq.
In such case, we should not setup irq offloading for a virtqueue.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Link: https://lore.kernel.org/r/20220222115428.998334-3-lingshan.zhu@intel.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e4d60009d908..04578aa87e4d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -97,8 +97,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
+	if (irq < 0)
+		return;
+
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	if (!vq->call_ctx.ctx || irq < 0)
+	if (!vq->call_ctx.ctx)
 		return;
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
-- 
2.35.1



