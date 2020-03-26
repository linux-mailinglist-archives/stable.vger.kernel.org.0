Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F35194C2D
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCZXX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgCZXX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:23:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE6420663;
        Thu, 26 Mar 2020 23:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265039;
        bh=Z4iMPj2/JljR+Vd2zFTtsyHkYIrKFgH9K7WTppGiQTU=;
        h=From:To:Cc:Subject:Date:From;
        b=wzceW/JqhJz3hvZl2SGUBeXhlcRUIaaVcnZtnaHlOL4+ir/8Sw0wjEmD9/eXYHjlA
         alqkXEY/LxFIab8OQNTWiaykhLek9kc9y5fIRkEKaZLdElfc2DzHyNjVTKMkZadRc3
         ampKLYGEJyZfnaJbvb39Q8qHzrJq3iUrOgfObtZk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 01/28] thunderbolt: Fix error code in tb_port_is_width_supported()
Date:   Thu, 26 Mar 2020 19:23:30 -0400
Message-Id: <20200326232357.7516-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e9d0e7511fda92a6511904996dd0aa57b6d7687a ]

This function is type bool, and it's supposed to return true on success.
Unfortunately, this path takes negative error codes and casts them to
bool (true) so it's treated as success instead of failure.

Fixes: 91c0c12080d0 ("thunderbolt: Add support for lane bonding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 43bfeb8866141..f0f77da6ca26d 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -848,7 +848,7 @@ static bool tb_port_is_width_supported(struct tb_port *port, int width)
 	ret = tb_port_read(port, &phy, TB_CFG_PORT,
 			   port->cap_phy + LANE_ADP_CS_0, 1);
 	if (ret)
-		return ret;
+		return false;
 
 	widths = (phy & LANE_ADP_CS_0_SUPPORTED_WIDTH_MASK) >>
 		LANE_ADP_CS_0_SUPPORTED_WIDTH_SHIFT;
-- 
2.20.1

