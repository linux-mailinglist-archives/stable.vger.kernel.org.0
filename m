Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4B2E15F4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgLWCzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729154AbgLWCU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D2D622273;
        Wed, 23 Dec 2020 02:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690042;
        bh=nyij9W/urw4bdVdrzt8UsQyrq9FKX/FOdgVLmsBrsao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohsSSvHKW8z6HFte4unJpSqxbrMM+BvhXRuj3D+Kx+MKS/JW6c6GJ0WuIwPylC7xx
         ESvMnfkAR6fXxaSQtBJ5ucmVVzlYNALlx2soNh182tpeOvETNTWfPfEXy2vMC9g5jU
         oDJF2vVRCULnttDT30JU7oPj92He6CqoBUhe3fKrxOLi1EJJ3x7Mp/MkOhtlzanMBD
         4+/mNhz3PIOibAAWAfUREx+vtsThBBYIkEG/CEjWeSKC/x/nGVeCpjRbUPjuAuoiA1
         xyxTqrtVWC9x88JGEsFcePQYtIcMiry+q0Np3e3ltLcUTkP7Z6UKj6PI2PYici5jWA
         oPdWY3o7ykc6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Tso <kyletso@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 115/130] USB: typec: tcpm: Add a 30ms room for tPSSourceOn in PR_SWAP
Date:   Tue, 22 Dec 2020 21:17:58 -0500
Message-Id: <20201223021813.2791612-115-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

[ Upstream commit fe79d5de77204dd946cfad76a9bec23354b1a500 ]

TCPM state machine needs 20-25ms to enter the ErrorRecovery state after
tPSSourceOn timer timeouts. Change the timer from max 480ms to 450ms to
ensure that the timer complies with the Spec. In order to keep the
flexibility for other usecases using tPSSourceOn, add another timer only
for PR_SWAP.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20201210160521.3417426-5-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 2 +-
 include/linux/usb/pd.h        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 0c0f251ab8a51..77a49e16e285e 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3451,7 +3451,7 @@ static void run_state_machine(struct tcpm_port *port)
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 			break;
 		}
-		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON);
+		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
 		break;
 	case PR_SWAP_SRC_SNK_SINK_ON:
 		tcpm_set_state(port, SNK_STARTUP, 0);
diff --git a/include/linux/usb/pd.h b/include/linux/usb/pd.h
index 6655ce32feff1..203fca353fdce 100644
--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -432,6 +432,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_DRP_SRC		30
 #define PD_T_PS_SOURCE_OFF	920
 #define PD_T_PS_SOURCE_ON	480
+#define PD_T_PS_SOURCE_ON_PRS	450	/* 390 - 480ms */
 #define PD_T_PS_HARD_RESET	30
 #define PD_T_SRC_RECOVER	760
 #define PD_T_SRC_RECOVER_MAX	1000
-- 
2.27.0

