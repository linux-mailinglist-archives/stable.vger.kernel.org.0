Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C735C03F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbhDLJL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238966AbhDLJHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C8C61249;
        Mon, 12 Apr 2021 09:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218220;
        bh=86SaYJXXRYHfptLMPiM5nQFdTmtQb+V33Nc0vrmstyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIz/1KI75dI5DIZH3Fl6VPgukmPHNTnf/5bnaJA0RGANRn/i29/i87AR4NvxKyUwE
         BupuYfgTcfEKD8b0EwGcwaTDHPNu1AOub4b3jgGcLVDcbunhMs7W324QyJGaisSfV1
         8QU+iN/JucJOgcYEA1Kfb4Dm42ahuXJ0YfuWTdyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 116/210] i40e: Added Asym_Pause to supported link modes
Date:   Mon, 12 Apr 2021 10:40:21 +0200
Message-Id: <20210412084019.865044274@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 90449e98c265296329446c7abcd2aae3b20c0bc9 ]

Add Asym_Pause to supported link modes (it is supported by HW).
Lack of Asym_Pause in supported modes can cause several problems,
i.e. it won't be possible to turn the autonegotiation on
with asymmetric pause settings (i.e. Tx on, Rx off).

Fixes: 4e91bcd5d47a ("i40e: Finish implementation of ethtool get settings")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 9e81f85ee2d8..a92fac6f1389 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1101,6 +1101,7 @@ static int i40e_get_link_ksettings(struct net_device *netdev,
 
 	/* Set flow control settings */
 	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(ks, supported, Asym_Pause);
 
 	switch (hw->fc.requested_mode) {
 	case I40E_FC_FULL:
-- 
2.30.2



