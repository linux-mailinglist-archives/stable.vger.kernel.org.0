Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025E26B96C7
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 14:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjCNNtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 09:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjCNNsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 09:48:32 -0400
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEFD9F061;
        Tue, 14 Mar 2023 06:45:31 -0700 (PDT)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 14 Mar
 2023 16:45:25 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 14 Mar
 2023 16:45:25 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lvc-project@linuxtesting.org>
Subject: [PATCH 5.4/5.10 1/1] RDMA/i40iw: Fix potential NULL-ptr-dereference
Date:   Tue, 14 Mar 2023 06:44:56 -0700
Message-ID: <20230314134456.3557-2-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314134456.3557-1-n.zhandarovich@fintech.ru>
References: <20230314134456.3557-1-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 5d9745cead1f121974322b94ceadfb4d1e67960e upstream.

in_dev_get() can return NULL which will cause a failure once idev is
dereferenced in in_dev_for_each_ifa_rtnl(). This patch adds a
check for NULL value in idev beforehand.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Changes made to the original patch during backporting:
Apply patch to drivers/infiniband/hw/i40iw/i40iw_cm.c instead of
drivers/infiniband/hw/irdma/cm.c due to the fact that kernel versions
5.10 and below use i40iw driver, not irdma.

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230126185230.62464-1-n.zhandarovich@fintech.ru
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 3053c345a5a3..e1236ac502f2 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1776,6 +1776,8 @@ static enum i40iw_status_code i40iw_add_mqh_4(
 			const struct in_ifaddr *ifa;
 
 			idev = in_dev_get(dev);
+			if (!idev)
+				continue;
 
 			in_dev_for_each_ifa_rtnl(ifa, idev) {
 				i40iw_debug(&iwdev->sc_dev,
-- 
2.25.1

