Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EEC383726
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbhEQPkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244908AbhEQPiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E0C61CF8;
        Mon, 17 May 2021 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262446;
        bh=InQ/DaQMQc5IC6GQp9VEPqpCpjRgNmmJMdj9NHRkRrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl4oz8a/EEKfxOJdR+54wyVtaDmtiLG3x/mbuKKoW3hqGSeCbsPf15I5r2k5jTgqC
         A+XdSsIYBhcdaA3KM56u9spjCCZWed6OhydlQf3zHILrtLNsP0PcMkyhia04r3qnoA
         i0qL2knygqkElvkNacp6bRqV17s5VIkZwBdtc88k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/289] i40e: Fix use-after-free in i40e_client_subtask()
Date:   Mon, 17 May 2021 16:01:54 +0200
Message-Id: <20210517140311.475914844@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index a2dba32383f6..32f3facbed1a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -375,6 +375,7 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
 				i40e_client_del_instance(pf);
+				return;
 			}
 		}
 	}
-- 
2.30.2



