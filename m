Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AAB177ECC
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgCCRrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbgCCRrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDEE2166E;
        Tue,  3 Mar 2020 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257620;
        bh=GL+ErFHzO4uUVjyhpYexc0RZkb4zGsFm7jDq9h5knZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ni+RyrOzH3+RpdHjEmroGzgYBCz0mCoz+O8XmxBpCpoUBu9SKq7+kMveKxscDhDYy
         DtWpyxktAS91c8e3CApRJFzlPo5jnwwn0vfrv6iOwBLo/smFyZwEy5T5uPdlaGhb8/
         R+AFRoEjhX2tv/L7grYFq40kh2CSpBp4jYjkHnQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 064/176] ice: Fix switch between FW and SW LLDP
Date:   Tue,  3 Mar 2020 18:42:08 +0100
Message-Id: <20200303174312.042559488@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 53977ee47410885e7d4eee87d2c811a48a275150 ]

When switching between FW and SW LLDP mode, the
number of configured TLV apps in the driver's
DCB configuration is getting out of synch with
what lldpad thinks is configured.  This is causing
a problem when shutting down lldpad.  The cleanup
is trying to delete TLV apps that are not defined
in the kernel.

Since the driver is keeping an accurate account
of the apps defined, use the drivers number of
apps to determine if there is an app to delete.
If the number of apps is <= 1, then do not
attempt to delete.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index d870c1aedc170..926c9772f0860 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -713,13 +713,13 @@ static int ice_dcbnl_delapp(struct net_device *netdev, struct dcb_app *app)
 		return -EINVAL;
 
 	mutex_lock(&pf->tc_mutex);
-	ret = dcb_ieee_delapp(netdev, app);
-	if (ret)
-		goto delapp_out;
-
 	old_cfg = &pf->hw.port_info->local_dcbx_cfg;
 
-	if (old_cfg->numapps == 1)
+	if (old_cfg->numapps <= 1)
+		goto delapp_out;
+
+	ret = dcb_ieee_delapp(netdev, app);
+	if (ret)
 		goto delapp_out;
 
 	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
-- 
2.20.1



