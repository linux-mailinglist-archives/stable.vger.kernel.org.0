Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2EA5491F0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378459AbiFMNlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379154AbiFMNj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173323DDC3;
        Mon, 13 Jun 2022 04:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B3661046;
        Mon, 13 Jun 2022 11:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F8FC3411C;
        Mon, 13 Jun 2022 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119741;
        bh=XYV1h9CdCm68f/OE4ysMTqhDqVh1boCsnpiBvrjKYfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt7VUN3IVNDTZ/0VdKezVoL2sk5XHvspWdhpTM6eG06PJiYU0OLkJb73l3iFWUWP8
         GZy2/QxgDTQx76NEqzOJXH0OgxiIvcqKiufbFeWSkWieY+qE92gFMaFTrxMZndX9aQ
         L6XqCh4Ve+qSvBsjPmEzWO+KogoD7FInAEcX/5gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 123/339] virtio: pci: Fix an error handling path in vp_modern_probe()
Date:   Mon, 13 Jun 2022 12:09:08 +0200
Message-Id: <20220613094930.241357719@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7a836a2aba09479c8e71fa43249eecc4af945f61 ]

If an error occurs after a successful pci_request_selected_regions() call,
it should be undone by a corresponding pci_release_selected_regions() call,
as already done in vp_modern_remove().

Fixes: fd502729fbbf ("virtio-pci: introduce modern device module")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <237109725aad2c3c03d14549f777b1927c84b045.1648977064.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 591738ad3d56..4093f9cca7a6 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -347,6 +347,7 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 err_map_isr:
 	pci_iounmap(pci_dev, mdev->common);
 err_map_common:
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vp_modern_probe);
-- 
2.35.1



