Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4065431A18
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJRMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 08:55:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25CEC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:52:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so70906279edv.12
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOuesFkbx8787dPIPc8Q8TOsbWXeYPQW0Qj4zGK36Z4=;
        b=H9zeVlnhAj85/5gphFStfQWyN+O+VvdcJzhxT+vlL7BP3qIeK2rNulZ5NiedfnAG4g
         or6uIgBDezS3dr6bP9xGu4f1IBPKWrI5wF+8Ml9jGmy4ABjao2Uka5UOWphhWpXmkVM3
         rNFrPvps40FEqQmIASri0zjZx4PNOTrhxvHw69kmmiB6zfJXQzMss8sByQfcOTV0EWbk
         OJGKDK6L36fZ3Q+HgJ7U2xQOeU2XC2F7LifFRkPBi70Y/Vx44o3ds7KgYa3s5luDpxLA
         ShbJ1Ym8jx9bfWjTRhtivUa35mL366L1otZ1U7U5WSlLbM6+fp3hF60314ZWu5rpIpoS
         IADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOuesFkbx8787dPIPc8Q8TOsbWXeYPQW0Qj4zGK36Z4=;
        b=cuQHhOLTcNyDrFznF5bQUDmJhee4NuJm/DxHj1SlG+uWTe3pbDPYj8xRnYPobA48eC
         P7bEWHrXGEw+FOCD7XOvetRmXFJdvqZMvY0as7Il0FozHlZehTPmVGaA/nzsRJ0iwSbJ
         dYQGBT/doM5yPQMbGf/mvaB+RkLLIlVXI1OFDrkPhXIQzrgPXM0G19NOVGlB3kwUrJKM
         7GZIW7+M64/dbcphKX9Zz5F31nEmBGp1RWoMy+46bOIJieLz3tx/F4DTXebOVfYb/JOV
         XnWfbybeu9Isj6fNAuIhda6KKA4TAagezUGmt0j4zrtC1/qo20dTATsQuz621zAzyNi0
         yJjw==
X-Gm-Message-State: AOAM532E8E2NoNlNxxBwFE1GCOdq15fj9pU5v0nsWs5bDJRRsMSxhENY
        yEpG6oj79670voCK3ZE+6FsiCirT+b0s62vg
X-Google-Smtp-Source: ABdhPJwGgdGAO5bdxTRO8P0AMtgBOdQk9K8KSeup0cxE5ppaMO1XJHtYIeNyfzw1HVu1r9RVOpLnIw==
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr44629676edd.94.1634561566091;
        Mon, 18 Oct 2021 05:52:46 -0700 (PDT)
Received: from dtpc.zanders.be (78-22-137-109.access.telenet.be. [78.22.137.109])
        by smtp.gmail.com with ESMTPSA id dh16sm9584498edb.63.2021.10.18.05.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:52:45 -0700 (PDT)
From:   Maarten Zanders <maarten.zanders@mind.be>
To:     stable@vger.kernel.org
Cc:     Maarten Zanders <maarten.zanders@mind.be>
Subject: [PATCH 5.10] net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's
Date:   Mon, 18 Oct 2021 14:52:20 +0200
Message-Id: <20211018125220.22190-1-maarten.zanders@mind.be>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mv88e6xxx_port_ppu_updates() interpretes data in the PORT_STS
register incorrectly for internal ports (ie no PPU). In these
cases, the PHY_DETECT bit indicates link status. This results
in forcing the MAC state whenever the PHY link goes down which
is not intended. As a side effect, LED's configured to show
link status stay lit even though the physical link is down.

Add a check in mac_link_down and mac_link_up to see if it
concerns an external port and only then, look at PPU status.

Difference from upstream commit:
ops->port_sync_link() renamed to ops->port_set_link()

Fixes: 5d5b231da7ac (net: dsa: mv88e6xxx: use PHY_DETECT in mac_link_up/mac_link_down)
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 18388ea5ebd9..afc5500ef8ed 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -726,7 +726,11 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
+	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
 	     mode == MLO_AN_FIXED) && ops->port_set_link)
 		err = ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 	mv88e6xxx_reg_unlock(chip);
@@ -749,7 +753,12 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
+	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	    mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
-- 
2.25.1

