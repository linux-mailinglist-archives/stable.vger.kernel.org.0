Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83758548A6B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiFMM6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354394AbiFMMzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67610543;
        Mon, 13 Jun 2022 04:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59BB060EF1;
        Mon, 13 Jun 2022 11:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BBEC34114;
        Mon, 13 Jun 2022 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118989;
        bh=T6ZSpYjX9kIN6bdYKRnBTZugulok050C0NWTF+1U8Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIpNIMmvZt5FzqNKH+veWioQKz1wYo6dHxb1KpODRPz+Bi8KYypigQvZ8+SJjX/LZ
         UZ6MxQCq7jRZJrK+U5ljYVU0wbX0f0Vwk3j0TVOVaudLg0joXaeG5ssAsJ/Jhw2z7I
         PUTsuW0Pbx7nBtI87rn1r6EcHc4I9AgHmltGKDbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/247] vdpa: ifcvf: set pci driver data in probe
Date:   Mon, 13 Jun 2022 12:10:02 +0200
Message-Id: <20220613094925.988710920@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit bd8bb9aed56b1814784a975e2dfea12a9adcee92 ]

We should set the pci driver data in probe instead of the vdpa device
adding callback. Otherwise if no vDPA device is created we will lose
the pointer to the management device.

Fixes: 6b5df347c6482 ("vDPA/ifcvf: implement management netlink framework for ifcvf")
Tested-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20220524055557.1938-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 003530b19b4e..4fe8aa13ac68 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -505,7 +505,6 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
 	}
 
 	ifcvf_mgmt_dev->adapter = adapter;
-	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
 
 	vf = &adapter->vf;
 	vf->dev_type = get_dev_type(pdev);
@@ -620,6 +619,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
+
 	return 0;
 
 err:
-- 
2.35.1



