Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34337CAA0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbhELQbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240914AbhELQZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42656619B0;
        Wed, 12 May 2021 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834532;
        bh=EOegCxrkTb4mmbhBbMhHZq+nxXOat+4HFt7I+Iaq0B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m06SciAUHqTukqRVn+OdgxVDxXo6sPOL6Ahz02zp16MKF/LGxqKEzab1g2CozPfPx
         Niy3MGIVGzrnAfQILtigKVzBOcpUcSqQ4eRGfe8EfWqCa6G+c4haRLd44FQG9+aXlo
         bFRldu6+U/bmLjlL1dxjOH90alkqfkI7JvbExJ6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 582/601] net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE
Date:   Wed, 12 May 2021 16:50:59 +0200
Message-Id: <20210512144847.013968899@linuxfoundation.org>
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

[ Upstream commit 6066234aa33850e9e35e7be82d92b9e9091e774b ]

The .serdes_get_lane op used the magic value 0xff to indicate a valid
SERDES lane and 0 signaled that a non-SERDES mode was set on the port.

Unfortunately, "0" is also a valid lane ID, so even when these ports
where configured to e.g. RGMII the driver would set them up as SERDES
ports.

- Replace 0xff with 0 to indicate a valid lane ID. The number is on
  the one hand just as arbitrary, but it is at least the first valid one
  and therefore less of a surprise.

- Follow the other .serdes_get_lane implementations and return -ENODEV
  in the case where no SERDES is assigned to the port.

Fixes: f5be107c3338 ("net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3195936dc5be..2ce04fef698d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -443,15 +443,15 @@ int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 u8 mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	/* There are no configurable serdes lanes on this switch chip but we
-	 * need to return non-zero so that callers of
+	 * need to return a non-negative lane number so that callers of
 	 * mv88e6xxx_serdes_get_lane() know this is a serdes port.
 	 */
 	switch (chip->ports[port].cmode) {
 	case MV88E6185_PORT_STS_CMODE_SERDES:
 	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
-		return 0xff;
-	default:
 		return 0;
+	default:
+		return -ENODEV;
 	}
 }
 
-- 
2.30.2



