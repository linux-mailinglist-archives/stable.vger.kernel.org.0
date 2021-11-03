Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A22C444067
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhKCLSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhKCLSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:18:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9581C061203
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 04:15:34 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u18so3001276wrg.5
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 04:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tl8+E8ke7LtSg9mrycn5obXJYXZJ74SWamHEJy1/0FI=;
        b=i3GpCHMLjzfOOM/ma1dTv4t5CMYstPQT+r8BrblC4leL3lkN45akJQZFw1Orc2fQkc
         aCFU5A8n7af6c5Q5qQIzNrA1038mXucc0V1MT31OAozPYehiKL1sw4PosE2GUBkGkKyX
         Cbvc9TmKHgb6ABAZ9iIShwNQ5HSU6KCAEoRukdd9u2itN2HheMW2LDg+P2ZGcg0Km2Hf
         jL7RCxgLCFbvV6uX9aZDdW5C1+pJHCbUjoIQz2IuvvK2njvLhAJRSVkufTTPdZT/VLZ4
         5jXD55PvWRbZltrbfJTuWbdEmbhj7F1moTu1cJnN44irJb1YUNhcSO4BYEDGe/EQ2gBv
         xtow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tl8+E8ke7LtSg9mrycn5obXJYXZJ74SWamHEJy1/0FI=;
        b=XOxZaXniBguSs6cu7OIJpRIZ3OMxChjzn8NuhgcE5b9EVb2G7B6WTUabxVgk11iQw9
         3ZC0jN15eCsJyI32P7isNHrcso0c0mF+SxNQxBVnmcESJj9dijLPYLGZ49UduQGLqyQE
         boF0Rijurou2Oq7Qi2sLcXGonect3WliOyhSm+V8xlg3JBW8exSlUbkTRMvwdqqJ1TOF
         TJSCLGXcgAajSHqYqKDl1PwcheSohqpxTHpLnP2Z9uckm4Cgi7GfJOHNtWl5osBlFKRu
         xn3xHnu12MaQ5b3p6+YtZpzT+/Je90wlwc2gcNhjg1i60nf8TrKK4gT7z8JbMsfhWpbd
         QmxQ==
X-Gm-Message-State: AOAM533rEXMTp5VANzgoFjiwtDiFzq2j0Z/rw8sgsmI7PdRezWJWR+dh
        m2d+gdnOI8MXUwZKSJbpf9JfDkC3QeY+Sg==
X-Google-Smtp-Source: ABdhPJwgzRDfcBFswA+zrzVGaYiwB4XgTNay8ZH8mnXc+XRdVkQQ3T++JGoLvWSSwjhbhIw4G1/Fdg==
X-Received: by 2002:a5d:4b82:: with SMTP id b2mr38467039wrt.419.1635938133167;
        Wed, 03 Nov 2021 04:15:33 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id j10sm1664507wru.15.2021.11.03.04.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 04:15:32 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     stable@vger.kernel.org
Cc:     Erik Ekman <erik@kryo.se>, "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] sfc: Fix reading non-legacy supported link modes
Date:   Wed,  3 Nov 2021 12:15:22 +0100
Message-Id: <20211103111522.111148-2-erik@kryo.se>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103111522.111148-1-erik@kryo.se>
References: <20211103111522.111148-1-erik@kryo.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 041c61488236a5a84789083e3d9f0a51139b6edf upstream,
with filename updated in backport to v5.4 and older.

Everything except the first 32 bits was lost when the pause flags were
added. This makes the 50000baseCR2 mode flag (bit 34) not appear.

I have tested this with a 10G card (SFN5122F-R7) by modifying it to
return a non-legacy link mode (10000baseCR).

Signed-off-by: Erik Ekman <erik@kryo.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/sfc/ethtool.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 86b965875540..d53e945dd08f 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -128,20 +128,14 @@ efx_ethtool_get_link_ksettings(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_link_state *link_state = &efx->link_state;
-	u32 supported;
 
 	mutex_lock(&efx->mac_lock);
 	efx->phy_op->get_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 
 	/* Both MACs support pause frames (bidirectional and respond-only) */
-	ethtool_convert_link_mode_to_legacy_u32(&supported,
-						cmd->link_modes.supported);
-
-	supported |= SUPPORTED_Pause | SUPPORTED_Asym_Pause;
-
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Asym_Pause);
 
 	if (LOOPBACK_INTERNAL(efx)) {
 		cmd->base.speed = link_state->speed;
-- 
2.33.1

