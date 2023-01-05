Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF52D65EBD8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjAENDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjAENC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A359D5C1D2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40BC7619F3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342F0C433EF;
        Thu,  5 Jan 2023 13:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923774;
        bh=jAY39tlgLh1vyRFy45qC6E6Y1yvHuw3YKF+MhmenTOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXX5ibcuGpTd3ZyHCgOYV2PG4qJIyvVTZ9x68BvpneFJRdMPyqI/VISIfgbyernJM
         Tgab2ekziNj4Giccht/VGyC1LtFTUTeSh39tKH1gz582fQy2NmP2+Z12yKrojIhCao
         sEOHB1PfRJmvYUYO76p7DbSePJ7atuUiXnuL56w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 098/251] drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
Date:   Thu,  5 Jan 2023 13:53:55 +0100
Message-Id: <20230105125339.298305297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 01de1123322e4fe1bbd0fcdf0982511b55519c03 ]

If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
needs to be freed.

Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 44caa7c2077e..d89d9247b7b9 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -222,6 +222,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 	return 0;
 
 qlcnic_destroy_async_wq:
+	while (i--)
+		kfree(sriov->vf_info[i].vp);
 	destroy_workqueue(bc->bc_async_wq);
 
 qlcnic_destroy_trans_wq:
-- 
2.35.1



