Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1A16760B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731906AbgBUIHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732033AbgBUIHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:07:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6344D2073A;
        Fri, 21 Feb 2020 08:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272428;
        bh=di+Zo++bk6Hy+GQT84NpmgmGGK9V84DgZQuKR743nwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07HiSagi7KG/xY6aa27gpbx7cUvTCitR/rz/YwqWEcZFzSKUBYwrLBJq//NORtV35
         uxBq/fLXcRBNYQKR2eEDpe1mzrowJfaxT8SzdSA90H3PSITDKLqkNbBeccoYBvd3W5
         6sJ6edya+42jC8pOFxFgvh1OsrQfJAKm457+/9HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/344] ipw2x00: Fix -Wcast-function-type
Date:   Fri, 21 Feb 2020 08:38:57 +0100
Message-Id: <20200221072401.374001398@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index 8dfbaff2d1fe2..a162146a43a72 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3206,8 +3206,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
+static void ipw2100_irq_tasklet(unsigned long data)
 {
+	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6007,7 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+static void ipw2100_irq_tasklet(unsigned long data);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6137,7 +6138,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw2100_irq_tasklet, (unsigned long)priv);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed0f06532d5e2..ac5f797fb1ad1 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1945,8 +1945,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(struct ipw_priv *priv)
+static void ipw_irq_tasklet(unsigned long data)
 {
+	struct ipw_priv *priv = (struct ipw_priv *)data;
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10680,7 +10681,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw_irq_tasklet, (unsigned long)priv);
 
 	return ret;
-- 
2.20.1



