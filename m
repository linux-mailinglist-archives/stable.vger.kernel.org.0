Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC64E286A
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348361AbiCUN5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348431AbiCUN5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F115DAB2;
        Mon, 21 Mar 2022 06:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E99B816C7;
        Mon, 21 Mar 2022 13:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E78BC340E8;
        Mon, 21 Mar 2022 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870904;
        bh=TkkZj9aVcrLNI81bYLasKDlzB/c1Awu5HVrJX/PLp48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+Z0uuKWxZvEuAmP2beHhgWT9T7N6jZrqoRQZH5XSyy9CmS04t3VwgWHCRJhxhVDE
         TeEE/L+ALD9ucbFbJeaZKIzGkd8GJCMIfTP+wzwoTp1M34lC6ym3TLVRz6sfvwdeCU
         6xDndbqlLBdOwvuVSsGGvUJcyaThDEUKbtnspTIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/57] atm: firestream: check the return value of ioremap() in fs_init()
Date:   Mon, 21 Mar 2022 14:51:53 +0100
Message-Id: <20220321133222.342173946@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit d4e26aaea7f82ba884dcb4acfe689406bc092dc3 ]

The function ioremap() in fs_init() can fail, so its return value should
be checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/firestream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index ef395b238816..f7880012b9a0 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1692,6 +1692,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
-- 
2.34.1



