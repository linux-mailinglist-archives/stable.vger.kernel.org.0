Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042D637CA7B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240322AbhELQag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236855AbhELQXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:23:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C0A361D96;
        Wed, 12 May 2021 15:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834446;
        bh=7bulX45fcz3DD0EPJQa8rI0mQiq6OC4fx+SlC6sQrxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlJYMzJk2u51J28A8K9Xlzn3jLFUd6yQDCfK/ucpBZyJZRGfTZTVe6qyrj/1pYY7Y
         Tpo+bCgRlM6+J8Zc+m2eAADRmAqCl0wB8kJV8WqneVio3pijkUrZPYZ1OtdnFhqV42
         GF31UkCPwzLbO1cRhHFI48+d0W2tLDne1kYYxqxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 546/601] net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
Date:   Wed, 12 May 2021 16:50:23 +0200
Message-Id: <20210512144845.843815554@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 281140a0a2ce4febf2c0ce5d29d0e7d961a826b1 ]

In the unlikely event of the VTU being loaded to the brim with 4k
entries, the last one was placed in the buffer, but the size reported
to devlink was off-by-one. Make sure that the final entry is available
to the caller.

Fixes: ca4d632aef03 ("net: dsa: mv88e6xxx: Export VTU as devlink region")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 21953d6d484c..ada7a38d4d31 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -678,7 +678,7 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 				sizeof(struct mv88e6xxx_devlink_atu_entry);
 			break;
 		case MV88E6XXX_REGION_VTU:
-			size = mv88e6xxx_max_vid(chip) *
+			size = (mv88e6xxx_max_vid(chip) + 1) *
 				sizeof(struct mv88e6xxx_devlink_vtu_entry);
 			break;
 		}
-- 
2.30.2



