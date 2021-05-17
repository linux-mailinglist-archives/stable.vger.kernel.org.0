Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFA53834A4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbhEQPLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242947AbhEQPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EAC561C29;
        Mon, 17 May 2021 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261800;
        bh=ysSzzWq83+bAihFpUjU/R8ZtCSyNJ369yjK25LYG5wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcqzOfOexCaSqXRyGuitDaIKAR1NKAQ/2PiAXUQjy2pwd5S+lT2bMajmHF2QVHK4g
         LSrQim8Xy+ex35ZLrgu0MFgExBhibLYt894YcZhZm+vCwBwtxx/TlEznhi/b2uFngG
         xBC9BYNz7FAH7OLIMYhHeNpofmTFQ8QBYsnzD6iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/141] i40e: Fix use-after-free in i40e_client_subtask()
Date:   Mon, 17 May 2021 16:02:24 +0200
Message-Id: <20210517140245.869735343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 38318f23a7ef86a8b1862e5e8078c4de121960c3 ]

Currently the call to i40e_client_del_instance frees the object
pf->cinst, however pf->cinst->lan_info is being accessed after
the free. Fix this by adding the missing return.

Addresses-Coverity: ("Read from pointer after free")
Fixes: 7b0b1a6d0ac9 ("i40e: Disable iWARP VSI PETCP_ENA flag on netdev down events")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index e81530ca08d0..5706abb3c0ea 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -377,6 +377,7 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
 				i40e_client_del_instance(pf);
+				return;
 			}
 		}
 	}
-- 
2.30.2



