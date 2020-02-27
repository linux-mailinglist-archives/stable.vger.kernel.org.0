Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7AF171FEA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgB0Oiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731995AbgB0Nzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B7F21D7E;
        Thu, 27 Feb 2020 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811738;
        bh=ZdKXL16m2JRHOwk/RKDSsE4rc/2dosS1CDBQNxazXCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHQplL8m33oAQ3QAisn7xX9gAmtXmYd3IvMzUCQgraNnfkPbtMb4pP+ekAgIDba+P
         n1Edvgcu2X1FbfdI7oXHJCXbm3xuwTR4E/ajziP7yP954X/U3pOm0K0xmU55S6MW2G
         VylFHGF0lFbpsg7qClA/ufVOrlycLHUPeFoqiOCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/237] ipw2x00: Fix -Wcast-function-type
Date:   Thu, 27 Feb 2020 14:34:57 +0100
Message-Id: <20200227132303.187913623@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit ebd77feb27e91bb5fe35a7818b7c13ea7435fb98 ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 19c442cb93e4a..8fbdd7d4fd0c2 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3220,8 +3220,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
+static void ipw2100_irq_tasklet(unsigned long data)
 {
+	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6027,7 +6028,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+static void ipw2100_irq_tasklet(unsigned long data);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6157,7 +6158,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw2100_irq_tasklet, (unsigned long)priv);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 8da87496cb587..2d0734ab3f747 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1966,8 +1966,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(struct ipw_priv *priv)
+static void ipw_irq_tasklet(unsigned long data)
 {
+	struct ipw_priv *priv = (struct ipw_priv *)data;
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10702,7 +10703,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw_irq_tasklet, (unsigned long)priv);
 
 	return ret;
-- 
2.20.1



