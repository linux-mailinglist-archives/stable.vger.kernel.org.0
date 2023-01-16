Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7966C0D8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjAPOFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAPOD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFEC21972;
        Mon, 16 Jan 2023 06:03:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B94860FD8;
        Mon, 16 Jan 2023 14:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EB4C433F1;
        Mon, 16 Jan 2023 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877780;
        bh=+faF3hepArrc352Tbtu73yFkegQ3khnMr0J0WFP+EaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2HdpjHb1Uf5MFTNrmx/9tF1YIVDaOvQ91gbIByaC5kmbdsUJGBCTwMhouKrc9I5c
         X4d7bHvF5oe5GJlULmypIIrh0R7DEeiVtr5Q/NFUalFZi3KeOjyrROuBTkwQ9wPs+k
         KYUrN5/D1k1iqmhc4P6CEEAJqw/dmFDo1v3RtIzNOH90Si1sjIzn717WwOuA8IiHq+
         3hqs2BOTgoiI0EGcsaVK2NfS0sltXIUzyp24ueEHNyYPAgXu7gH3vN/6KgLdUtZqwa
         QvGTd78aBPrj//HPAf/l/4UC42Y5AtExsmZ3eRK6Wg9CwqTUcVH2JYbqCXu6REXSqF
         /qZNKzumScBNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>,
        Oleksii Moisieiev <oleksii_moisieiev@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 6.1 21/53] xen/pvcalls: free active map buffer on pvcalls_front_free_map
Date:   Mon, 16 Jan 2023 09:01:21 -0500
Message-Id: <20230116140154.114951-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
2.35.1

