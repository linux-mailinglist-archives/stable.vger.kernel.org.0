Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB537C7DF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhELQDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238211AbhELP5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F65961946;
        Wed, 12 May 2021 15:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833460;
        bh=kF7IKPrB1ZmisWWIppxEjmAVxp7etSL5QF6Nm/CBarY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tBoVqMUFf8sj60KhR5mGzqy5qSJvQNUNgqlvl4oH4IOwnMmwHM+BH5tONNxjUa3q
         LQmN/+KKk7d0BvcRUf8B3E5gRS82OIGt5rKhBZOp9H8knkmFnHSzRCfPErnz9zcxY/
         fAZmCLYV9gAKnf5ROFUU3V8ZAqoIzs3y/Bryhizc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 159/601] usb: typec: tcpm: Handle vbus shutoff when in source mode
Date:   Wed, 12 May 2021 16:43:56 +0200
Message-Id: <20210512144833.071054384@linuxfoundation.org>
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

From: Badhri Jagan Sridharan <badhri@google.com>

[ Upstream commit 7771bcc7f5a727d6e3f7a80b0b075a75cb664fb2 ]

While in source mode, vbus could be shutoff by protections
circuits. TCPM does not move back to toggling state to
re-initiate connection. Fix this by moving to SRC_UNATTACHED
state when vbus shuts off while in source mode.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20210201100212.49863-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a443094090f1..c2bdfeb60e4f 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4287,6 +4287,17 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 		/* Do nothing, waiting for sink detection */
 		break;
 
+	case SRC_STARTUP:
+	case SRC_SEND_CAPABILITIES:
+	case SRC_SEND_CAPABILITIES_TIMEOUT:
+	case SRC_NEGOTIATE_CAPABILITIES:
+	case SRC_TRANSITION_SUPPLY:
+	case SRC_READY:
+	case SRC_WAIT_NEW_CAPABILITIES:
+		/* Force to unattached state to re-initiate connection */
+		tcpm_set_state(port, SRC_UNATTACHED, 0);
+		break;
+
 	case PORT_RESET:
 		/*
 		 * State set back to default mode once the timer completes.
-- 
2.30.2



