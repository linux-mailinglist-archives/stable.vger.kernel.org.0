Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1728C4D8167
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiCNLmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbiCNLl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10233434BC;
        Mon, 14 Mar 2022 04:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1A1D6118B;
        Mon, 14 Mar 2022 11:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A719FC340EC;
        Mon, 14 Mar 2022 11:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257970;
        bh=HQDzt7DRnstbuSIZ9hqLQDqQhgyT8/fAxqbSn2TWsus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uetaO+0n2pIRdIm0SMrBOYIKiXkwOppEVONNeyWV1ND7WvS7T4YNks97lavsgNQib
         q6FI++L2BY0/iXUI/2YTm06APtpkU3oDe9hGSnKmeLHdArQPPQk6gwN4MWlIqcdfxk
         pjTjGfVyKpYZYrHJU2AnWdIKWy2bRov/nCXGvLI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 4.19 23/30] virtio: unexport virtio_finalize_features
Date:   Mon, 14 Mar 2022 12:34:41 +0100
Message-Id: <20220314112732.449033983@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 838d6d3461db0fdbf33fc5f8a69c27b50b4a46da upstream.

virtio_finalize_features is only used internally within virtio.
No reason to export it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio.c |    3 +--
 include/linux/virtio.h  |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -165,7 +165,7 @@ void virtio_add_status(struct virtio_dev
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
-int virtio_finalize_features(struct virtio_device *dev)
+static int virtio_finalize_features(struct virtio_device *dev)
 {
 	int ret = dev->config->finalize_features(dev);
 	unsigned status;
@@ -185,7 +185,6 @@ int virtio_finalize_features(struct virt
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(virtio_finalize_features);
 
 static int virtio_dev_probe(struct device *_d)
 {
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -151,7 +151,6 @@ void virtio_break_device(struct virtio_d
 void virtio_config_changed(struct virtio_device *dev);
 void virtio_config_disable(struct virtio_device *dev);
 void virtio_config_enable(struct virtio_device *dev);
-int virtio_finalize_features(struct virtio_device *dev);
 #ifdef CONFIG_PM_SLEEP
 int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);


