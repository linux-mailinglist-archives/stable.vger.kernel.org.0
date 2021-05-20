Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F9938A4F3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhETKK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhETKJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E153061954;
        Thu, 20 May 2021 09:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503749;
        bh=Kj4HbNKnJggx//K0o2PWTc0JJc/yOjHg4wctrBeg3yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mvg0NaCrHehyZFsrO5pUGRrqrtDp8AMh93hIviaCMYZ9ZOYhG6nwO7h5a8chg80yM
         gtckJouEQb3oDB6fJv1kujdA1l4As3XtwwLhmeTyk6hRevg2MSQ1LGd4NWr2y9LXtN
         BRbqtIKBHLTF/Qv0pIPvL7lbkO37uN+oaYZ0t4rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 361/425] i40e: Fix use-after-free in i40e_client_subtask()
Date:   Thu, 20 May 2021 11:22:10 +0200
Message-Id: <20210520092143.268323885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 5f3b8b9ff511..c1832a848714 100644
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



