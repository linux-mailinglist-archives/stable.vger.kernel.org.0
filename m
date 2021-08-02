Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85203DD8FE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhHBN4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235914AbhHBNyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CED610FE;
        Mon,  2 Aug 2021 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912380;
        bh=fxTKlP8bCqlQHIzZGwX0bK1SBTINMya2l7UTR2QEIg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNqh/5Td5mgy+lQc5twhm3lgCjsIaL/XrZL++3qXOucVI8rhgRhGB0N2CFc28BEgz
         Ovszwxvk88c+gJZiSvStbHJMjcmJIblOI7b8VD0NB0T+RM6SR6DmYcT+gnz2+zddss
         I5YNTTz1DBrGl2nOvexO08ZY9oL3PaM9Otca4+w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/67] i40e: Fix firmware LLDP agent related warning
Date:   Mon,  2 Aug 2021 15:44:57 +0200
Message-Id: <20210802134340.183880856@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 71d6fdba4b2d82fdd883fec31dee77fbcf59773a ]

Make warning meaningful for the user.

Previously the trace:
"Starting FW LLDP agent failed: error: I40E_ERR_ADMIN_QUEUE_ERROR, I40E_AQ_RC_EAGAIN"
was produced when user tried to start Firmware LLDP agent,
just after it was stopped with sequence:
ethtool --set-priv-flags <dev> disable-fw-lldp on
ethtool --set-priv-flags <dev> disable-fw-lldp off
(without any delay between the commands)
At that point the firmware is still processing stop command, the behavior
is expected.

Fixes: c1041d070437 ("i40e: Missing response checks in driver when starting/stopping FW LLDP")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 874073f7f024..a952ae07d253 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5106,6 +5106,10 @@ flags_complete:
 					dev_warn(&pf->pdev->dev,
 						 "Device configuration forbids SW from starting the LLDP agent.\n");
 					return -EINVAL;
+				case I40E_AQ_RC_EAGAIN:
+					dev_warn(&pf->pdev->dev,
+						 "Stop FW LLDP agent command is still being processed, please try again in a second.\n");
+					return -EBUSY;
 				default:
 					dev_warn(&pf->pdev->dev,
 						 "Starting FW LLDP agent failed: error: %s, %s\n",
-- 
2.30.2



