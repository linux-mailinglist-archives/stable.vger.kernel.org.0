Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664FB5407C7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbiFGRwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348811AbiFGRuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B261B136E84;
        Tue,  7 Jun 2022 10:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91A65B822AD;
        Tue,  7 Jun 2022 17:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03666C385A5;
        Tue,  7 Jun 2022 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623445;
        bh=dH0S1Yx6zrSM5IxdG+1OP2rxQf/4LsW0I4ixaV6Elkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdOE6Al3rBjr+y1Eu6U5Xl80NJ2c9rCO5QPPL9jCJtjhMVVBTeVZxBPwn5DZpvwSu
         qxXkTVD4wZfK7JvaLxr7gwCLYWckJ46LPWP8acwlGFA5o31YzesJsii1SG7CqfwrYl
         bbEHa3f6EiBKHbccNTu5KojTklVwWBvnBat4DNVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 5.10 379/452] drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem
Date:   Tue,  7 Jun 2022 19:03:56 +0200
Message-Id: <20220607164919.857703213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit e168c25526cd0368af098095c2ded4a008007e1b upstream.

When the mapping is already reaped the unmap must be a no-op, as we
would otherwise try to remove the mapping twice, corrupting the involved
data structures.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Guido Günther <agx@sigxcpu.org>
Acked-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -282,6 +282,12 @@ void etnaviv_iommu_unmap_gem(struct etna
 
 	mutex_lock(&context->lock);
 
+	/* Bail if the mapping has been reaped by another thread */
+	if (!mapping->context) {
+		mutex_unlock(&context->lock);
+		return;
+	}
+
 	/* If the vram node is on the mm, unmap and remove the node */
 	if (mapping->vram_node.mm == &context->mm)
 		etnaviv_iommu_remove_mapping(context, mapping);


