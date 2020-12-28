Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3A2E6570
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgL1QBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390963AbgL1NcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54498207FF;
        Mon, 28 Dec 2020 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162281;
        bh=3MvjJK7NXXo0b+heKUPMqD3OjLCvrvsPV5iXJXMW0hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De+bLqHOJ/PzWyIkpjbzaNsBC0AqXZYvRtGhFPZ53mCSxaxjo5ygoiYi91EHWN7fI
         ENvtkfLD0WEfTsECif0jyYO0dRFli8nvga3OOqJ9yKheifgPJPSloaSn3JVbErUh2K
         3nU1+579F9Z6afIqzCb5mtY0Y2fRAYCOlhZN+DEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/346] qlcnic: Fix error code in probe
Date:   Mon, 28 Dec 2020 13:49:27 +0100
Message-Id: <20201228124931.765807638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index dbd48012224f2..ed34b7d1a9e11 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2508,6 +2508,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		qlcnic_sriov_vf_register_map(ahw);
 		break;
 	default:
+		err = -EINVAL;
 		goto err_out_free_hw_res;
 	}
 
-- 
2.27.0



