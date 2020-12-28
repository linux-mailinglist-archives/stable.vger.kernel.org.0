Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DE2E3D45
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440155AbgL1ONZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440158AbgL1ONX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAC35206D8;
        Mon, 28 Dec 2020 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164788;
        bh=viPBgMreGWdxLX96yFg9b+DQ1cPOL1SE5DYqkihxFt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGJCdyhXuEL4T+nfl1qNMH3tPVPQTqw7sbQOZV0dajw5DFZsJmzPZv8aKJA/mtjxv
         faZfQelDNn51DOJizzOEErODr/i/6KWVi+t3/qzT5kkS4N/q9KSCSdk0EEJMH9iWmw
         lZDPYsEK5dhuc+EE4jmaDnPKdgozAxxLgkyZ+Vm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/717] soc: rockchip: io-domain: Fix error return code in rockchip_iodomain_probe()
Date:   Mon, 28 Dec 2020 13:44:56 +0100
Message-Id: <20201228125035.304415094@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit c2867b2e710fc85bb39c6f6e5948450c48e8a33e ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: e943c43b32ce ("PM: AVS: rockchip-io: Move the driver to the rockchip specific drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607070805-33038-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/io-domain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/rockchip/io-domain.c b/drivers/soc/rockchip/io-domain.c
index eece97f97ef8f..b29e829e815e5 100644
--- a/drivers/soc/rockchip/io-domain.c
+++ b/drivers/soc/rockchip/io-domain.c
@@ -547,6 +547,7 @@ static int rockchip_iodomain_probe(struct platform_device *pdev)
 		if (uV < 0) {
 			dev_err(iod->dev, "Can't determine voltage: %s\n",
 				supply_name);
+			ret = uV;
 			goto unreg_notify;
 		}
 
-- 
2.27.0



