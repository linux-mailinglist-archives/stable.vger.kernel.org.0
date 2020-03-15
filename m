Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144CB185E3A
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 16:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgCOPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 11:33:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45344 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgCOPdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 11:33:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id b22so6692555pls.12
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 08:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=1SA2cimOPOyWAvYTqxOpgCWc9l5osdm3C7Zo8QPdNUw=;
        b=Vm3k1lAIXMMxg0UBlDqyvjNIo4zoo/94KdznUb05vN2MlJGJd8OCDgyDiIDmAJSBQl
         NqTgK/fb554M9VOaia4eim4YEU5Vkh3O70OCFgxfBx67i6nOsgxdZaTMARcFuaM5Htxy
         jmWnq/kwR23g/mKRu8DkM1OfiG35Cfs8ndUTKMMgj2HJ7idLYYPq4HaFE/cCaH9NUwXb
         Y8Ma6SOxu3dK/eO1R8TOaxiq7w4eqOQ6JoW+4Ba9hvLBZEj8W6CzpQ8KoiOqhfWl/3Cv
         LmUkuE52K95ZdYEvKpvjC7dt1wlZuHfm/y7wnYYVucsxk4Fn3XJh+obEYyIMSxXBnr2S
         2+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=1SA2cimOPOyWAvYTqxOpgCWc9l5osdm3C7Zo8QPdNUw=;
        b=ZZn7msgZfzT6xU024YcF3lgwE1e7a4s6ffNcuDycMziGQisd23lysUULgtMRd3HAfh
         L/Ys+tNAZku/ewjACbOgJENVs50KhFqVgBZMsu5fbk3vBLBiIS8Ii6fWyPeyl68tF2ZP
         Uq7R3C8W3aib0wx+q0asotYgBhqGkUbDV/JgUn/azM5Zbs3GKYOaW/VKxV+teQtl+25I
         XPZELw5aclerudxKCoE4MMqnlx9vXNWi0C278oF7YmNqFNxTJmimQOWj8kV6b1vXkfTs
         WV6xtSvj6HubPKe61Jz03MH7az4jD/8LqvZXpJp0IQ3NTtaVQEFdTE0UYMiasIrxuhP0
         9ZAw==
X-Gm-Message-State: ANhLgQ1Xnrv7vCcGxQs41SDdluqFyR/5eFfUmFxYc4FIhlI7pN4FJuOt
        orUc9AwEp6pY0TTo7h/x5EOUp8AO1f0=
X-Google-Smtp-Source: ADFU+vvpy63TKSMMXCck9aCl2XQK26d7KW6MEG6NT3YaX4jOTANiylwC4zL8bwVdqnR0BsbXmGMBVQ==
X-Received: by 2002:a17:902:bb93:: with SMTP id m19mr330767pls.26.1584286397306;
        Sun, 15 Mar 2020 08:33:17 -0700 (PDT)
Received: from DESKTOP-DJ7UMF3 (bb121-7-89-109.singnet.com.sg. [121.7.89.109])
        by smtp.gmail.com with ESMTPSA id w138sm21156007pff.145.2020.03.15.08.33.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 08:33:16 -0700 (PDT)
Date:   Sun, 15 Mar 2020 23:33:16 +0800
From:   Darell Tan <darell.tan@gmail.com>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch
Subject: [PATCH v2] net: phy: Fix marvell_set_downshift() from clobbering
 MSCR register
Message-Id: <20200315233316.91fe2daa5915fb7123812edb@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix marvell_set_downshift() from clobbering MSCR register.

A typo in marvell_set_downshift() clobbers the MSCR register. This
register also shares settings with the auto MDI-X detection, set by
marvell_set_polarity(). In the 1116R init, downshift is set after
polarity, causing the polarity settings to be clobbered.

This bug is present on the 5.4 series and was introduced in commit
6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
helper"). This patch need not be forward-ported to 5.5 because the
affected functions were rewritten.

Fixes: 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a helper")
Signed-off-by: Darell Tan <darell.tan@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: David S. Miller <davem@davemloft.net>
---
changes v2:
  - added tags to sign-off area
  - resubmitted to stable list from netdev, as instructed by David Miller

 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a7796134e..6ab8fe339 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -282,7 +282,7 @@ static int marvell_set_downshift(struct phy_device *phydev, bool enable,
 	if (reg < 0)
 		return reg;
 
-	reg &= MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
+	reg &= ~MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
 	reg |= ((retries - 1) << MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT);
 	if (enable)
 		reg |= MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-- 
2.17.1
