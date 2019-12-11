Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4839011B031
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbfLKPUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732348AbfLKPUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA8A22527;
        Wed, 11 Dec 2019 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077634;
        bh=1xSY9jCPlfXG4Gzkm4kdzMo4hdl0dW8Kuh9oik0A7+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5fcwWboaxKmYSc6NtrAQIYmB1dsFnOaDujt/Jjkk74kjsJcu9UuTfVtgW0WGCOy3
         SDAGS888LXtFnWcM6xsp5OJ0tYJj3d9czVx6RAUNNPzFcrgjBJEp8J3aFAJg+8cfEG
         Au+1LgcdBJ+PBuZ15yfhNDaQukbfP1NRXFj5UAAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/243] ice: Fix possible NULL pointer de-reference
Date:   Wed, 11 Dec 2019 16:03:56 +0100
Message-Id: <20191211150344.096155673@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

[ Upstream commit f25dad19ba70f7cc135da78ec013325042cd8c52 ]

A recent update to smatch is causing it to report the error "we previously
assumed 'm_entry->vsi_list_info' could be null". Fix that.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 4012adbab0112..1bfc59dff51f7 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1023,6 +1023,9 @@ ice_handle_vsi_list_mgmt(struct ice_hw *hw,
 		u16 vsi_id = new_fltr->fwd_id.vsi_id;
 		enum ice_adminq_opc opcode;
 
+		if (!m_entry->vsi_list_info)
+			return ICE_ERR_CFG;
+
 		/* A rule already exists with the new VSI being added */
 		if (test_bit(vsi_id, m_entry->vsi_list_info->vsi_map))
 			return 0;
-- 
2.20.1



