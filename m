Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A086D1013B9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfKSF0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbfKSF0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA62A21783;
        Tue, 19 Nov 2019 05:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141204;
        bh=D1rUFAEoxivuyV+8XxQoXNAmDa10eseEAYfig+KkLKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVdRJQgM6Ibbbv6dFHik+rbe3T/+RQTmL4Q51Rw0ry+dHKESo0ZIgAdjUqqZukneE
         3KVUamngDA+O5AyfCs2sZfknh29Zql564rEtsijmCvpxYHCo7xw3z0k3WuELwedN4W
         XRvqdn0srJs6w2Q3Fqv9yoS8+MePYndQHxNDozxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihong Yang <lihong.yang@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/422] i40evf: set IFF_UNICAST_FLT flag for the VF
Date:   Tue, 19 Nov 2019 06:14:37 +0100
Message-Id: <20191119051404.674982958@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lihong Yang <lihong.yang@intel.com>

[ Upstream commit e65aae086330d0a6c6c9f874aef03c69cf98884b ]

Set IFF_UNICAST_FLT flag for the VF to prevent it from entering
promiscuous mode when macvlan is added to the VF.

Signed-off-by: Lihong Yang <lihong.yang@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index fef6d892ed4cf..bc4fa9df6da3e 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3332,6 +3332,8 @@ int i40evf_process_config(struct i40evf_adapter *adapter)
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+
 	/* Do not turn on offloads when they are requested to be turned off.
 	 * TSO needs minimum 576 bytes to work correctly.
 	 */
-- 
2.20.1



