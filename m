Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA3540F7E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiFGTJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354819AbiFGTJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:09:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2E4192261;
        Tue,  7 Jun 2022 11:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BD94616B6;
        Tue,  7 Jun 2022 18:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382EEC385A5;
        Tue,  7 Jun 2022 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625169;
        bh=wROjKPocEJBbittAMQhxhJUUWC4+PmUgeUKiA0tkmOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXE5RBPsDTZTItc+Dd5f5YvpyTRkcR1zCaYIQuBWoJb8HEiAdfRWMu3a/+4rFMBvy
         pN0Qg6LmXBjZBs1O8MqTEOyPUPOORu9Sg+6exk1aVmNtcy9ZvgM2YqRv4cy7LioEpf
         FZgJ+2WNH2h1fEVKisLhaPBUWUnsx7rvUO07HV84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 5.15 590/667] drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem
Date:   Tue,  7 Jun 2022 19:04:15 +0200
Message-Id: <20220607164952.379802310@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
@@ -286,6 +286,12 @@ void etnaviv_iommu_unmap_gem(struct etna
 
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


