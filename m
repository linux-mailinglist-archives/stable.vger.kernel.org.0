Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E258E126D41
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfLSTJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfLSSkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4D4124682;
        Thu, 19 Dec 2019 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780819;
        bh=UtmX9GiSmxXu/9EaoD1243Db0uC3Xo+gs5g7A8/UcsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqncGjWuKi/fLpHIQS2be4zVK6Eb7WRA3U6dLVnhO0MKaxrN/n2rJq8Y+gT0UwH0E
         q1BENUwo0V6UQlJ4zCeeD2jKV8z0x4vMKOF4WtfPZQ4IsSb4R2Fi+lMQPei+drkQtS
         JCcZFV2O3yXz8YKl1zUYKqZPobhwgp05JZiGIDsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 130/162] e100: Fix passing zero to PTR_ERR warning in e100_load_ucode_wait
Date:   Thu, 19 Dec 2019 19:33:58 +0100
Message-Id: <20191219183215.686862734@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit cd0d465bb697a9c7bf66a9fe940f7981232f1676 ]

Fix a static code checker warning:
drivers/net/ethernet/intel/e100.c:1349
 e100_load_ucode_wait() warn: passing zero to 'PTR_ERR'

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 068789e694c9b..93c29094ceff9 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1370,8 +1370,8 @@ static inline int e100_load_ucode_wait(struct nic *nic)
 
 	fw = e100_request_firmware(nic);
 	/* If it's NULL, then no ucode is required */
-	if (!fw || IS_ERR(fw))
-		return PTR_ERR(fw);
+	if (IS_ERR_OR_NULL(fw))
+		return PTR_ERR_OR_ZERO(fw);
 
 	if ((err = e100_exec_cb(nic, (void *)fw, e100_setup_ucode)))
 		netif_err(nic, probe, nic->netdev,
-- 
2.20.1



