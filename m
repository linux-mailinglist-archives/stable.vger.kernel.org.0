Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C1681048
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbjA3OCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbjA3OBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F0D3B0D5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98569B81178
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F2C433D2;
        Mon, 30 Jan 2023 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087297;
        bh=MOo7qzN4sSUM/M5OPfcHXFC2YA7Ca6yG6CsgHmg5k4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xh6xZwAyG1uAwcPnMcnqlRY+FKfQivS96L+VGuYu/utf1IA02KKGNIDxMRolcM9hg
         hi+m8S451EHnrD6zlcwEnYPbUXDCKNW3igl/mnZ9S2wGrYMjxcrdhPOpDl3QXfOnn6
         lFqdHkAc47ucOQrLW5vORbPKwWxiPS3pQQucbcrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oleksii Moisieiev <oleksii_moisieiev@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/313] xen/pvcalls: free active map buffer on pvcalls_front_free_map
Date:   Mon, 30 Jan 2023 14:49:56 +0100
Message-Id: <20230130134344.170447954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>

[ Upstream commit f57034cedeb6e00256313a2a6ee67f974d709b0b ]

Data buffer for active map is allocated in alloc_active_ring and freed
in free_active_ring function, which is used only for the error
cleanup. pvcalls_front_release is calling pvcalls_front_free_map which
ends foreign access for this buffer, but doesn't free allocated pages.
Call free_active_ring to clean all allocated resources.

Signed-off-by: Oleksii Moisieiev <oleksii_moisieiev@epam.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/6a762ee32dd655cbb09a4aa0e2307e8919761311.1671531297.git.oleksii_moisieiev@epam.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 1826e8e67125..9b569278788a 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -225,6 +225,8 @@ static irqreturn_t pvcalls_front_event_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void free_active_ring(struct sock_mapping *map);
+
 static void pvcalls_front_free_map(struct pvcalls_bedata *bedata,
 				   struct sock_mapping *map)
 {
@@ -240,7 +242,7 @@ static void pvcalls_front_free_map(struct pvcalls_bedata *bedata,
 	for (i = 0; i < (1 << PVCALLS_RING_ORDER); i++)
 		gnttab_end_foreign_access(map->active.ring->ref[i], NULL);
 	gnttab_end_foreign_access(map->active.ref, NULL);
-	free_page((unsigned long)map->active.ring);
+	free_active_ring(map);
 
 	kfree(map);
 }
-- 
2.39.0



