Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED94D82F7
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbiCNML5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242809AbiCNMK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27922FFD6;
        Mon, 14 Mar 2022 05:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C149B80DF6;
        Mon, 14 Mar 2022 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F98C340EC;
        Mon, 14 Mar 2022 12:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259784;
        bh=NPgAG/TFqciHsybR6ESBeZHQsOLy1/BLnmY9oLRjOR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12RuueaP5ig0Ar/92L8JaX3ceECT5v32PzWSAgHGb2+OnugY5fxLyz6Wi8vhW/lB6
         KRBONIrAtRhZH0qCCOTPAuKXU10Z6RGcpLJknhbABQeZfE+e8vyhCTMzCwD0rE/bi+
         B2RMICPwFpgdm0ByL4LWLc+cXu/IkOCRisMSnI5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.15 089/110] virtio: unexport virtio_finalize_features
Date:   Mon, 14 Mar 2022 12:54:31 +0100
Message-Id: <20220314112745.514952116@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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
@@ -166,7 +166,7 @@ void virtio_add_status(struct virtio_dev
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
-int virtio_finalize_features(struct virtio_device *dev)
+static int virtio_finalize_features(struct virtio_device *dev)
 {
 	int ret = dev->config->finalize_features(dev);
 	unsigned status;
@@ -202,7 +202,6 @@ int virtio_finalize_features(struct virt
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(virtio_finalize_features);
 
 static int virtio_dev_probe(struct device *_d)
 {
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -133,7 +133,6 @@ bool is_virtio_device(struct device *dev
 void virtio_break_device(struct virtio_device *dev);
 
 void virtio_config_changed(struct virtio_device *dev);
-int virtio_finalize_features(struct virtio_device *dev);
 #ifdef CONFIG_PM_SLEEP
 int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);


