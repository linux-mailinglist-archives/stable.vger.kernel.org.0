Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A11235BE6E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbhDLI6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238638AbhDLI4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1377A61286;
        Mon, 12 Apr 2021 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217777;
        bh=86SaYJXXRYHfptLMPiM5nQFdTmtQb+V33Nc0vrmstyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvpBxfT9N4XXSs5HF82xasWLr9Eg2RPUGlZhD+Jze/Qcr8WeSxbNw1b1zsBs8VPHX
         yZTDPTcUyhTn58VdBRUW9iF0TrgZXtS9cRHYsdGq4L5C2yjcpbdiD+W494zVUxb07y
         taU9AEHG+cNtMHNC8y9/Smc8w9Jlo9BlNzb+b0zo=
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
Subject: [PATCH 5.10 106/188] i40e: Added Asym_Pause to supported link modes
Date:   Mon, 12 Apr 2021 10:40:20 +0200
Message-Id: <20210412084017.171056161@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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



