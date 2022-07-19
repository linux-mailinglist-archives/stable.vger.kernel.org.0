Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE7F579EC2
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242858AbiGSNFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbiGSNDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A279CE04;
        Tue, 19 Jul 2022 05:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC5AB81B08;
        Tue, 19 Jul 2022 12:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B0CC341C6;
        Tue, 19 Jul 2022 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233572;
        bh=aArpVS4VNheVFDiOhTep3qwKK7+LFJJviBSs/dkrB5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrYtGqCH0WIRI5jC8zIbhI1PsP/iDbEDiGBj4MeotyNGzhQDHPdWLVdSGq1KmYsPg
         wYeOOsTFNxNg7sqtkjTyMxxbjcEboEjF8+YApLf0HGHcgNOAIuCudnLEd60ufeBTIs
         DMNW4/nnRhsQZvbtYxLIssw6Rb35z2IJjDlN2CKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 167/231] virtio_mmio: Restore guest page size on resume
Date:   Tue, 19 Jul 2022 13:54:12 +0200
Message-Id: <20220719114728.202958489@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 7522832529dd..fe696aafaed8 100644
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



