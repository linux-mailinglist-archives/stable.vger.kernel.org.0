Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A164A0E1
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiLLNcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiLLNcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:32:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9B6BED
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 011ABB80D55
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A8EC433EF;
        Mon, 12 Dec 2022 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851934;
        bh=8VnjgRBhaM2Et1c02AY5ECrC5bDgkZVGbjm9eKwy2kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbN2+Vw1vCmZZgii5gi2YzXGkzG2HtdQJk3JC8YRmZqIs7JpdvVIlGwVDhTbkDWqB
         kfXUtrNph+IvpjC01lEXHyL8EDDcxFSWap9ehas4E4FHtqlr54wzBkbmFJ5OlkD6nq
         jRLtuG8gBNVWyhUwg7ReyODzyN9gDlYD8ZvzJpx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yongqiang Liu <liuyongqiang13@huawei.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/123] net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq
Date:   Mon, 12 Dec 2022 14:17:46 +0100
Message-Id: <20221212130931.359196192@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 42330a32933fb42180c52022804dcf09f47a2f99 ]

The nicvf_probe() won't destroy workqueue when register_netdev()
failed. Add destroy_workqueue err handle case to fix this issue.

Fixes: 2ecbe4f4a027 ("net: thunderx: replace global nicvf_rx_mode_wq work queue for all VFs to private for each of them.")
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20221203094125.602812-1-liuyongqiang13@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index a27227aeae88..b43b97e15a6f 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2250,7 +2250,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2259,6 +2259,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
-- 
2.35.1



