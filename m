Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C7517FDF0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgCJMtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbgCJMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785C320674;
        Tue, 10 Mar 2020 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844590;
        bh=ujHYlmvzzmARpzykN3UJl7tQFXD5glbjjzu9OoZqoc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctcI/s6XNwi4x8g7YLM6p1XFIHlkJ26u6NXNalXhMbmwFopDVVVUol/J9JMRUZOKs
         6pF2NXWk6g6VTd+JVncNXvbfhS+bMYbz/1GVVwQTQIeEmuWh3W3kJCWU5zVto7toIs
         5LM48hZ4dZsYR5ylDfFKZdABibFNX7qJYeC1uql0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/168] ice: Dont tell the OS that link is going down
Date:   Tue, 10 Mar 2020 13:38:13 +0100
Message-Id: <20200310123640.127645637@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

[ Upstream commit 8a55c08d3bbc9ffc9639f69f742e59ebd99f913b ]

Remove code that tell the OS that link is going down when user
change flow control via ethtool. When link is up it isn't certain
that link goes down after 0x0605 aq command. If link doesn't go
down, OS thinks that link is down, but physical link is up. To
reset this state user have to take interface down and up.

If link goes down after 0x0605 command, FW send information
about that and after that driver tells the OS that the link goes
down. So this code in ethtool is unnecessary.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1fe9f6050635d..62673e27af0e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2916,13 +2916,6 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	else
 		return -EINVAL;
 
-	/* Tell the OS link is going down, the link will go back up when fw
-	 * says it is ready asynchronously
-	 */
-	ice_print_link_msg(vsi, false);
-	netif_carrier_off(netdev);
-	netif_tx_stop_all_queues(netdev);
-
 	/* Set the FC mode and only restart AN if link is up */
 	status = ice_set_fc(pi, &aq_failures, link_up);
 
-- 
2.20.1



