Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4154F2E67EF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgL1Qar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgL1NG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2F4A208D5;
        Mon, 28 Dec 2020 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160745;
        bh=SmTaqo7WzE/EmaufsDZ7mCiHw4+6ilbbmMuXd2r1WVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UL/1aMYjPtcBv6eWEWMudJPxtsbOHOpzRs5aUC9xhSt2Ux0nExGijKX0Sul94EkHB
         i42MFHrIxSxqNccPaLnQVdhIs0PYRQmMrveDJICsFxkyVDejcGQqmE6coG4J50sZ8t
         9pS/HpGFFSXhrZgiRXj6g0VTPVuxE8hl0mc4CJ58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 126/175] qlcnic: Fix error code in probe
Date:   Mon, 28 Dec 2020 13:49:39 +0100
Message-Id: <20201228124859.359088678@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0d52848632a357948028eab67ff9b7cc0c12a0fb ]

Return -EINVAL if we can't find the correct device.  Currently it
returns success.

Fixes: 13159183ec7a ("qlcnic: 83xx base driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X9nHbMqEyI/xPfGd@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index ebf5ead16939a..0928da21efd04 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2507,6 +2507,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		qlcnic_sriov_vf_register_map(ahw);
 		break;
 	default:
+		err = -EINVAL;
 		goto err_out_free_hw_res;
 	}
 
-- 
2.27.0



