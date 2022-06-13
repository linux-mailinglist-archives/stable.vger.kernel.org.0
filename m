Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6DD5493E0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382489AbiFMOZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382866AbiFMOWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:22:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39879A26FF;
        Mon, 13 Jun 2022 04:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9EFDB80D31;
        Mon, 13 Jun 2022 11:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB21C34114;
        Mon, 13 Jun 2022 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120650;
        bh=hHXElzreZ9LF69NloOsVdVXf/pv3tv3lyHSk/iLVSBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1uW94obYBJyfTICNxeXGx+Ze5MzwqIADCL5XPEKP9n8mrLR3+1aC3SAXQayeMMR9
         uv/gRzACib/JAdxMreUswFqE/eB+uGxbv15ZuLTgjxxEGsLAkaW3njyjMKn9R29EVh
         h+3R3Aw1pXigdFGp8NuKLnVtpXSFEcrvN9HMG4YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 107/298] virtio: pci: Fix an error handling path in vp_modern_probe()
Date:   Mon, 13 Jun 2022 12:10:01 +0200
Message-Id: <20220613094928.194453365@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index e8b3ff2b9fbc..6f6187fe8893 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -340,6 +340,7 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 err_map_isr:
 	pci_iounmap(pci_dev, mdev->common);
 err_map_common:
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vp_modern_probe);
-- 
2.35.1



