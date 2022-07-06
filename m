Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A064D568DD5
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiGFPex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiGFPeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CCA27FF6;
        Wed,  6 Jul 2022 08:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0845661FF9;
        Wed,  6 Jul 2022 15:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4085C341C8;
        Wed,  6 Jul 2022 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121580;
        bh=mC7wYh07JK50tJslQVx5F4oC6FD+eTXlRQ0ZX62rplc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t10nhBOr7qNBHS80Xba19T0QL3U0Gzy6ADs322WqIrTGhb5hSh4VHLAvee/mDQ7dp
         ZOYqm7EkILKn2MoyXh2AYVVVwpBAXgNZPsSbH/f9+br9Z4bUfOV43jRBf58ATAMuOt
         wLP+hbbpDykxvJhoPVLfu+uIE1Z42tHPGLdaM9LSF5yl2qOlBwK1Sz7gbaES+OC777
         wCJVxFWMDv6O71fdFPlgncr+UZpGBU49/SwbcwaPFbZm7OJJFVEQHqVqebLKPLa6Qj
         HZJESvEuPFnGkbMa7W4DoHTLRtn5WNZRnp3GGYfimWg3CBu9jYqdhGBENKpYXpygmc
         vr+dxFWpsvjnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 02/11] virtio_mmio: Restore guest page size on resume
Date:   Wed,  6 Jul 2022 11:32:47 -0400
Message-Id: <20220706153256.1598411-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153256.1598411-1-sashal@kernel.org>
References: <20220706153256.1598411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit e0c2ce8217955537dd5434baeba061f209797119 ]

Virtio devices might lose their state when the VMM is restarted
after a suspend to disk (hibernation) cycle. This means that the
guest page size register must be restored for the virtio_mmio legacy
interface, since otherwise the virtio queues are not functional.

This is particularly problematic for QEMU that currently still defaults
to using the legacy interface for virtio_mmio. Write the guest page
size register again in virtio_mmio_restore() to make legacy virtio_mmio
devices work correctly after hibernation.

Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Message-Id: <20220621110621.3638025-3-stephan.gerhold@kernkonzept.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7dec1418bf7c..e8ef0c66e558 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -556,6 +556,9 @@ static int virtio_mmio_restore(struct device *dev)
 {
 	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
 
+	if (vm_dev->version == 1)
+		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_GUEST_PAGE_SIZE);
+
 	return virtio_device_restore(&vm_dev->vdev);
 }
 
-- 
2.35.1

