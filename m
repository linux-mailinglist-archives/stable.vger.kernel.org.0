Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD1445123D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbhKOTde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244468AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C663634C2;
        Mon, 15 Nov 2021 18:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000475;
        bh=jkFTcjtBw+PC9lAlj7hyaiOrMJggtUV8lZ4n6EdMMBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nW6eFZVdpU8xUHBb/c1cYOh6Bp8JAJ2rvrTPvMj08t3FQY5WFgrnr2rwPGIQ4sUOj
         +4OXnhZ0OCC4tozX9fEiQzWa3bdlOcZQ3nnbKZGuj6vpfToJ0ZtNg/dz/Xr0+bxGhJ
         0Hf6ha7hY36nr2kg73pXU1lX2TViUstMhnL7ngUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 640/849] phy: ti: gmii-sel: check of_get_address() for failure
Date:   Mon, 15 Nov 2021 18:02:03 +0100
Message-Id: <20211115165441.929819245@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8d55027f4e2c04146a75fb63371ab96ccc887f2c ]

Smatch complains that if of_get_address() returns NULL, then "size"
isn't initialized.  Also it would lead to an Oops.

Fixes: 7f78322cdd67 ("phy: ti: gmii-sel: retrieve ports number and base offset from dt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Link: https://lore.kernel.org/r/20210914110038.GB11657@kili
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-gmii-sel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index 5fd2e8a08bfcf..d0ab69750c6b4 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -320,6 +320,8 @@ static int phy_gmii_sel_init_ports(struct phy_gmii_sel_priv *priv)
 		u64 size;
 
 		offset = of_get_address(dev->of_node, 0, &size, NULL);
+		if (!offset)
+			return -EINVAL;
 		priv->num_ports = size / sizeof(u32);
 		if (!priv->num_ports)
 			return -EINVAL;
-- 
2.33.0



