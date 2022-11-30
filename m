Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255C863DFB1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiK3Stl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiK3Sta (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A04A064
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C068B61D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE087C433D7;
        Wed, 30 Nov 2022 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834169;
        bh=fcAr0vvF9W6th+6C9MtIqOqp2loFGEe+K29akyDgpiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2nuojKpKPY5czRXEPfmNHK9M7Oe4xIlVQHJINnlee7hNAzQfiS7MPHJ/6XIRvU7U
         F8dukZV243OEU9HKwmoNElSHnoN6XnFFPn4VFpyyE8pF9uQnB7xVh5nESdKss2fhAY
         jrg0pOqET6YJOBmJ/d324Y6wxVwz0LS8rhZkyfLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 155/289] octeontx2-af: Fix reference count issue in rvu_sdp_init()
Date:   Wed, 30 Nov 2022 19:22:20 +0100
Message-Id: <20221130180547.648730326@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ad17c2a3f11b0f6b122e7842d8f7d9a5fcc7ac63 ]

pci_get_device() will decrease the reference count for the *from*
parameter. So we don't need to call put_device() to decrease the
reference. Let's remove the put_device() in the loop and only decrease
the reference count of the returned 'pdev' for the last loop because it
will not be passed to pci_get_device() as input parameter. We don't need
to check if 'pdev' is NULL because it is already checked inside
pci_dev_put(). Also add pci_dev_put() for the error path.

Fixes: fe1939bb2340 ("octeontx2-af: Add SDP interface support")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Link: https://lore.kernel.org/r/20221123065919.31499-1-wangxiongfeng2@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
index b04fb226f708..ae50d56258ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
@@ -62,15 +62,18 @@ int rvu_sdp_init(struct rvu *rvu)
 		pfvf->sdp_info = devm_kzalloc(rvu->dev,
 					      sizeof(struct sdp_node_info),
 					      GFP_KERNEL);
-		if (!pfvf->sdp_info)
+		if (!pfvf->sdp_info) {
+			pci_dev_put(pdev);
 			return -ENOMEM;
+		}
 
 		dev_info(rvu->dev, "SDP PF number:%d\n", sdp_pf_num[i]);
 
-		put_device(&pdev->dev);
 		i++;
 	}
 
+	pci_dev_put(pdev);
+
 	return 0;
 }
 
-- 
2.35.1



