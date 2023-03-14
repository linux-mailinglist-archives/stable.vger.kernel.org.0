Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD7C6B96C5
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 14:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCNNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjCNNsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 09:48:23 -0400
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D40E9BE35;
        Tue, 14 Mar 2023 06:45:22 -0700 (PDT)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 14 Mar
 2023 16:45:20 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 14 Mar
 2023 16:45:20 +0300
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
Subject: [PATCH 5.4/5.10 0/1] RDMA/i40iw: Fix potential NULL-ptr-dereference
Date:   Tue, 14 Mar 2023 06:44:55 -0700
Message-ID: <20230314134456.3557-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
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

This is a modified backport of upstream commit 5d9745cead1f. It corrects
NULL pointer dereference in in_dev_for_each_ifa_rtnl() caused by
potential device unavailability. This issue can be triggered on
5.4/5.10 stable branches.

Changes had to be made to the modified source file in question. Patch
 drivers/infiniband/hw/i40iw/i40iw_cm.c
instead of:
 drivers/infiniband/hw/irdma/cm.c
due to switch from i40iw to irdma driver in commit fa0cf568fd76.
i40iw driver was removed and irdma was introduced as an alias to i40iw.

Other than the filename change, the patch remains the same and can be
cleanly applied to stable branches listed above.

