Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629AE2F331
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfE3DOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfE3DOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 343FA2455A;
        Thu, 30 May 2019 03:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186063;
        bh=x52xSQcRLnHEtP7iS+OxBtvzLr/KCfJjhMr/CA3AdOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnXxYUFl6DSALuys9FnsLdkQaCIQ3xh/nzhbDGXaR/l97o5yYDJ/pvhCFNrnSHMC4
         00v1rWVU2s+yDNwuqZHDn8hQgkAzXanBUsC+a7TvU7mcqxG0g+kdxlulEYizMSjLvb
         uH9rmJFybv1Hb57EvtvxnU5IDusF9aICE216ty3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 172/346] i40e: dont allow changes to HW VLAN stripping on active port VLANs
Date:   Wed, 29 May 2019 20:04:05 -0700
Message-Id: <20190530030549.873841495@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bfb0ebed53857cfc57f11c63fa3689940d71c1c8 ]

Modifying the VLAN stripping options when a port VLAN is configured
will break traffic for the VSI, and conceptually doesn't make sense,
so don't allow this.

Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e4ff531db14a9..3a3382613263e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2654,6 +2654,10 @@ void i40e_vlan_stripping_enable(struct i40e_vsi *vsi)
 	struct i40e_vsi_context ctxt;
 	i40e_status ret;
 
+	/* Don't modify stripping options if a port VLAN is active */
+	if (vsi->info.pvid)
+		return;
+
 	if ((vsi->info.valid_sections &
 	     cpu_to_le16(I40E_AQ_VSI_PROP_VLAN_VALID)) &&
 	    ((vsi->info.port_vlan_flags & I40E_AQ_VSI_PVLAN_MODE_MASK) == 0))
@@ -2684,6 +2688,10 @@ void i40e_vlan_stripping_disable(struct i40e_vsi *vsi)
 	struct i40e_vsi_context ctxt;
 	i40e_status ret;
 
+	/* Don't modify stripping options if a port VLAN is active */
+	if (vsi->info.pvid)
+		return;
+
 	if ((vsi->info.valid_sections &
 	     cpu_to_le16(I40E_AQ_VSI_PROP_VLAN_VALID)) &&
 	    ((vsi->info.port_vlan_flags & I40E_AQ_VSI_PVLAN_EMOD_MASK) ==
-- 
2.20.1



