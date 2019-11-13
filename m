Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14755FA088
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfKMBuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfKMBuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136502245B;
        Wed, 13 Nov 2019 01:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609845;
        bh=ag3Pt1+cczd014vnvka/WOIYakAcbIlIgSnRJhqISu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CA9YIf0q6W0Y4izY11kM0aMFCd3tZc+GjjNxUa9V6uWyPhkEPWxwFSBlQfBKG/1LP
         HNcwjFzTYYojgZWw8njq/GQvPyy5otPMeAYj/IRPk7/07m5FQxtIa5OG6y1Q0SeW6l
         owjJ+rcwQJ8DbpVH1jLMaxp3iIX6GdjqtW8UuSnw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 017/209] IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds
Date:   Tue, 12 Nov 2019 20:47:13 -0500
Message-Id: <20191113015025.9685-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
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

