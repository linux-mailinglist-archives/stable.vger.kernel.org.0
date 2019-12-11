Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF35511B546
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbfLKPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731900AbfLKPUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4A9208C3;
        Wed, 11 Dec 2019 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077601;
        bh=MDPQbXfIzz95FDeFh5TA0B89QcPp6G1c8uengSOHZG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhU7ooBgVtvoh7lNyMGQqX3xp0s0IyyPGh1RsSj0A/+/+k01IH1YW7zzLMgIKh9YR
         Q80qL0SIM243PrZ+UvIoDAhgZ7iN7cqX4tYujwKPZU8CdZFqnFKDMxonJR3mK2dP2J
         a1rsgr7OqAycTswZD6q5FadphyLeCYqB3QhYP49M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link state for HS
Date:   Wed, 11 Dec 2019 16:04:21 +0100
Message-Id: <20191211150345.799359877@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <thinh.nguyen@synopsys.com>

[ Upstream commit 0d36dede457873404becd7c9cb9d0f2bcfd0dcd9 ]

Highspeed device and below has different state names than superspeed and
higher. Add proper checks and printouts of link states for highspeed and
below.

Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/debug.h   | 29 +++++++++++++++++++++++++++++
 drivers/usb/dwc3/debugfs.c | 19 +++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index c66d216dcc304..4f75ab3505b77 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -116,6 +116,35 @@ dwc3_gadget_link_string(enum dwc3_link_state link_state)
 	}
 }
 
+/**
+ * dwc3_gadget_hs_link_string - returns highspeed and below link name
+ * @link_state: link state code
+ */
+static inline const char *
+dwc3_gadget_hs_link_string(enum dwc3_link_state link_state)
+{
+	switch (link_state) {
+	case DWC3_LINK_STATE_U0:
+		return "On";
+	case DWC3_LINK_STATE_U2:
+		return "Sleep";
+	case DWC3_LINK_STATE_U3:
+		return "Suspend";
+	case DWC3_LINK_STATE_SS_DIS:
+		return "Disconnected";
+	case DWC3_LINK_STATE_RX_DET:
+		return "Early Suspend";
+	case DWC3_LINK_STATE_RECOV:
+		return "Recovery";
+	case DWC3_LINK_STATE_RESET:
+		return "Reset";
+	case DWC3_LINK_STATE_RESUME:
+		return "Resume";
+	default:
+		return "UNKNOWN link state\n";
+	}
+}
+
 /**
  * dwc3_trb_type_string - returns TRB type as a string
  * @type: the type of the TRB
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index df8e73ec3342e..04ce7c01a09e6 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -433,13 +433,17 @@ static int dwc3_link_state_show(struct seq_file *s, void *unused)
 	unsigned long		flags;
 	enum dwc3_link_state	state;
 	u32			reg;
+	u8			speed;
 
 	spin_lock_irqsave(&dwc->lock, flags);
 	reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 	state = DWC3_DSTS_USBLNKST(reg);
-	spin_unlock_irqrestore(&dwc->lock, flags);
+	speed = reg & DWC3_DSTS_CONNECTSPD;
 
-	seq_printf(s, "%s\n", dwc3_gadget_link_string(state));
+	seq_printf(s, "%s\n", (speed >= DWC3_DSTS_SUPERSPEED) ?
+		   dwc3_gadget_link_string(state) :
+		   dwc3_gadget_hs_link_string(state));
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
 }
@@ -457,6 +461,8 @@ static ssize_t dwc3_link_state_write(struct file *file,
 	unsigned long		flags;
 	enum dwc3_link_state	state = 0;
 	char			buf[32];
+	u32			reg;
+	u8			speed;
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
@@ -477,6 +483,15 @@ static ssize_t dwc3_link_state_write(struct file *file,
 		return -EINVAL;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	reg = dwc3_readl(dwc->regs, DWC3_DSTS);
+	speed = reg & DWC3_DSTS_CONNECTSPD;
+
+	if (speed < DWC3_DSTS_SUPERSPEED &&
+	    state != DWC3_LINK_STATE_RECOV) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return -EINVAL;
+	}
+
 	dwc3_gadget_set_link_state(dwc, state);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
2.20.1



