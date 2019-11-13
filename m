Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A75FA152
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfKMB4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbfKMB4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E8E222D4;
        Wed, 13 Nov 2019 01:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610195;
        bh=W6Cv9nYKuyieexMWJNDnH/JK4Gkfrg+rFkLPx5ydw7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHdawAVYP+uama5eNeEV3CPDxXoVSSPrv3jfwKOjXKESu6ZKViTyhxMwRi1zKiMpF
         a+l+j59Zr0dRz4RNzGF4cwBf4zdA81mbgEBDCov/zP2SMw4PO4BMfde8mReqQZdVwW
         1d2wC9oynw9f4gB2Z5Cm7ux63pn972pa/5CRWlKg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 009/115] IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds
Date:   Tue, 12 Nov 2019 20:54:36 -0500
Message-Id: <20191113015622.11592-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

[ Upstream commit 3144533bf667c8e53bb20656b78295960073e57b ]

The dlid assignment made by looking into the u_ucast_dlid array does not
do an explicit check for the size of the array. The code path to arrive at
def_port, the index value is long and complicated so its best to just have
an explicit check here.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
index a72278e9cd274..9c8ddaaa6fbbf 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
@@ -351,7 +351,8 @@ static uint32_t opa_vnic_get_dlid(struct opa_vnic_adapter *adapter,
 			if (unlikely(!dlid))
 				v_warn("Null dlid in MAC address\n");
 		} else if (def_port != OPA_VNIC_INVALID_PORT) {
-			dlid = info->vesw.u_ucast_dlid[def_port];
+			if (def_port < OPA_VESW_MAX_NUM_DEF_PORT)
+				dlid = info->vesw.u_ucast_dlid[def_port];
 		}
 	}
 
-- 
2.20.1

