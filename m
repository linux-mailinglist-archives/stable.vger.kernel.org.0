Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E548328533
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhCAQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhCAQnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C254364F47;
        Mon,  1 Mar 2021 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616193;
        bh=I+/Qt8wNvswLieb34kwTLegTpmM9jm2d6FVTDqfsMpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6YpS5OSNnlOzjdp4+R2Rr+BzJFXh0gI4dmyUV5nE3US7NRSAgYZ+hC+espJsWDZq
         yxxppoziy2B37+EIm6nfJtoGZxoYnW88wBMdLSgYzRRclkW5feZ1RQcDq5HmTkeLSw
         Kjiz7JjtCwNxI4MgD3r4kd73r8UqchYlQNh2cp9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/176] b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
Date:   Mon,  1 Mar 2021 17:11:49 +0100
Message-Id: <20210301161022.775861097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 4773acf3d4b50768bf08e9e97a204819e9ea0895 ]

The documentation for the PHY update [1] states:

Loop 4 times with index i

    If PHY Revision >= 3
        Copy table[i] to coef[i]
    Otherwise
        Set coef[i] to 0

the copy of the table to coef is currently implemented the wrong way
around, table is being updated from uninitialized values in coeff.
Fix this by swapping the assignment around.

[1] https://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal/

Fixes: 2f258b74d13c ("b43: N-PHY: implement restoring general configuration")
Addresses-Coverity: ("Uninitialized scalar variable")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index a5557d70689f4..d1afa74aa144b 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5320,7 +5320,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 
 	for (i = 0; i < 4; i++) {
 		if (dev->phy.rev >= 3)
-			table[i] = coef[i];
+			coef[i] = table[i];
 		else
 			coef[i] = 0;
 	}
-- 
2.27.0



