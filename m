Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B22328BB5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhCASij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239800AbhCASc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:32:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 682E464FFD;
        Mon,  1 Mar 2021 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618538;
        bh=Xi+lVabsYrHZBkh8p7HoHsOstLPyg4ZYJ4SjuvdVzLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAWbKFyDPJg8v5vqWDZaDI1O1QXij84wDIV/m2Q4m5flrqVEcn4kgyFxJN1L0Ort0
         xufwp4lw3ZTcHdHNpzXcpeHZROya6oYzlcTSQAEe8qHR3NNNhQ2ult2r4m5y7GIyn6
         gqkD736ja0taLztSdWFa9smoLF5/z81B9thoQ1U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/663] b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
Date:   Mon,  1 Mar 2021 17:06:11 +0100
Message-Id: <20210301161147.829701812@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index b669dff24b6e0..665b737fbb0d8 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5311,7 +5311,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 
 	for (i = 0; i < 4; i++) {
 		if (dev->phy.rev >= 3)
-			table[i] = coef[i];
+			coef[i] = table[i];
 		else
 			coef[i] = 0;
 	}
-- 
2.27.0



