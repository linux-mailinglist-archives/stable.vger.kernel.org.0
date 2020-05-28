Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4461E664D
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404410AbgE1Pib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 11:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404383AbgE1Pi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 11:38:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C389C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 08:38:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s69so3327241pjb.4
        for <stable@vger.kernel.org>; Thu, 28 May 2020 08:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NeLbl/+8xKX6o3sZjRzYtVgt0IhtUUu09mrfbqcnSNI=;
        b=EsMjsWD4es8LaQXZqqs4oGibdOW6H4kLJx507YDUUjnpiFVg1Ekq6eb1K7tygOAtsP
         0keCim/iJiCcVzj4mphvrCYHCo3uYjhCzIms3qAdXftyV8Y4JU3vURdUziK1JeYeQfc1
         MTTqnNIhamuPC/cWFrgiLMpPFciQ2CDYDPvJFXKO6tw6PLDCYd+4Qd01c8Rpf0OjXREV
         +ZiDnMdGLjlK4BpgtyJFmHBxUKSJLCg1RER69crVdqlUxoswqBHaLO9sWuulhEiz78GI
         u5zvIyKQMOGdypUCZArdFYHqca3IBv9ppZIjpN8zLo2s+Do5vwjqsbJ60LdqkH3+mJdh
         IjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NeLbl/+8xKX6o3sZjRzYtVgt0IhtUUu09mrfbqcnSNI=;
        b=ZYQ8DNPoBGLb6IKSitbkizlPxXyVVt2+1Q1h+sjqRNflJVZWGK8JS3Iy8LeGjs/gn7
         SoZffs+TwFYkwyQ2lXprChE5LWyaPz1e9rvhyZp5J6b50wHvXSdOX66DjbprPGdtxnYL
         8pnNLGntg+P2Zdmq9Ugi0bnz+/2Q6KfSauzL6uFR/5HKLA9/j9ppnsd++oyb8h/v1EQT
         ZxXLCuuHmJW1q30bxc7Qo3uW/Y/oHqFiCLssSUcwqItTZe6Io8podiUizppq8wDcPcly
         SJNJmOBK/IkLqHbx7cx/d1xnY8GfwLPNgaIu37OW6gqPNOsZqxY/jotwdK0D5y9f5Cxh
         Xb8g==
X-Gm-Message-State: AOAM531SoUR5nbGWLWCkPDpbmH5wVDxRInFUV7/Vsgd9fx1cd/eM88/+
        wqMZLOCxpHutVyRn1E59kMUzzA2L
X-Google-Smtp-Source: ABdhPJyBwEK5FpnwQSojoT6yeCRXVFILQ+N4zvI9MIJComydLo31eGWfOj/Id+8AoKpcX/dpHp52ag==
X-Received: by 2002:a17:90a:2a8e:: with SMTP id j14mr4389332pjd.136.1590680306664;
        Thu, 28 May 2020 08:38:26 -0700 (PDT)
Received: from P65xSA.lan ([128.199.164.101])
        by smtp.gmail.com with ESMTPSA id y5sm6245122pjp.27.2020.05.28.08.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 08:38:25 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.4] net: dsa: mt7530: set CPU port to fallback mode
Date:   Thu, 28 May 2020 23:38:14 +0800
Message-Id: <20200528153814.4899-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 38152ea37d8bdaffa22603e0a5b5b86cfa8714c9 ]

Currently, setting a bridge's self PVID to other value and deleting
the default VID 1 renders untagged ports of that VLAN unable to talk to
the CPU port:

	bridge vlan add dev br0 vid 2 pvid untagged self
	bridge vlan del dev br0 vid 1 self
	bridge vlan add dev sw0p0 vid 2 pvid untagged
	bridge vlan del dev sw0p0 vid 1
	# br0 cannot send untagged frames out of sw0p0 anymore

That is because the CPU port is set to security mode and its PVID is
still 1, and untagged frames are dropped due to VLAN member violation.

Set the CPU port to fallback mode so untagged frames can pass through.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/mt7530.c | 11 ++++++++---
 drivers/net/dsa/mt7530.h |  6 ++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index cffaf4fdd772..7b81a39c15c1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -821,10 +821,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
 
 	/* Trapped into security mode allows packet forwarding through VLAN
-	 * table lookup.
+	 * table lookup. CPU port is set to fallback mode to let untagged
+	 * frames pass through.
 	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-		   MT7530_PORT_SECURITY_MODE);
+	if (dsa_is_cpu_port(ds, port))
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_FALLBACK_MODE);
+	else
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_SECURITY_MODE);
 
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 756140b7dfd5..f8d5e82ddab2 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -147,6 +147,12 @@ enum mt7530_port_mode {
 	/* Port Matrix Mode: Frames are forwarded by the PCR_MATRIX members. */
 	MT7530_PORT_MATRIX_MODE = PORT_VLAN(0),
 
+	/* Fallback Mode: Forward received frames with ingress ports that do
+	 * not belong to the VLAN member. Frames whose VID is not listed on
+	 * the VLAN table are forwarded by the PCR_MATRIX members.
+	 */
+	MT7530_PORT_FALLBACK_MODE = PORT_VLAN(1),
+
 	/* Security Mode: Discard any frame due to ingress membership
 	 * violation or VID missed on the VLAN table.
 	 */
-- 
2.26.2

