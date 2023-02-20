Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3515669CE60
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjBTN7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjBTN67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0694696
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D8BB80D4E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0791BC433A0;
        Mon, 20 Feb 2023 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901447;
        bh=YbHyk0Yj5v83mAWPoPN0CrKwF2Uiw38KjLu6b9b2vaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by2l9203CBt8KLyA1dBEv+iGx5D9dorRoQETlKYLwf4nOmCG2KlnkAbH3mtcMuKYg
         ppkWX/X18ZzGD9jz8kvZG1zWEcZm2BwI6Kcu4bJhMXBq6XzfuTD+qKbanenocDD9LD
         J6ntnHLREflzk9a1E37ulEMOLHAF0x+Yybygq+k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tanmay Bhushan <007047221b@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/118] vdpa: ifcvf: Do proper cleanup if IFCVF init fails
Date:   Mon, 20 Feb 2023 14:35:36 +0100
Message-Id: <20230220133601.223778811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Tanmay Bhushan <007047221b@gmail.com>

[ Upstream commit 6b04456e248761cf68f562f2fd7c04e591fcac94 ]

ifcvf_mgmt_dev leaks memory if it is not freed before
returning. Call is made to correct return statement
so memory does not leak. ifcvf_init_hw does not take
care of this so it is needed to do it here.

Signed-off-by: Tanmay Bhushan <007047221b@gmail.com>
Message-Id: <772e9fe133f21fa78fb98a2ebe8969efbbd58e3c.camel@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f9c0044c6442e..44b29289aa193 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -849,7 +849,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-		return ret;
+		goto err;
 	}
 
 	for (i = 0; i < vf->nr_vring; i++)
-- 
2.39.0



