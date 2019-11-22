Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52984106EE6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfKVLME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbfKVK6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C4A20721;
        Fri, 22 Nov 2019 10:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420321;
        bh=ag3Pt1+cczd014vnvka/WOIYakAcbIlIgSnRJhqISu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpguQTBfQnFew3bpPpuHouErgfkrGZt3bwUOzA+SAV1hLxBcNGIiWKYgUqu8uU1IB
         Q+5zOL+eS+BTJPRhcWMZ6PZnDphej4Wxn8ErBVSBAq8v3f0FbQWoyzZ+wGkwrVvY3U
         AxbcXxlY3lc7dCjZ3zKG0GHRN4jxONimeX4vA98k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/220] IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds
Date:   Fri, 22 Nov 2019 11:26:35 +0100
Message-Id: <20191122100914.567211523@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 267da8215e08f..31cd361416ac9 100644
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



