Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270202E143B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgLWCWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgLWCWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0AC422573;
        Wed, 23 Dec 2020 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690157;
        bh=5s9eCR6AG18jWWaNdD4IAvSoLw6UzNuCppY10rtEZIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbQB8FCKnewWcV0+p05RBq4J5D0TCSJZ91yd/cdVJ6/uZjiyLrvpOA2VHbSMvjz7S
         NhB8krhpBLDsiW76DryuWUVysQeplKCOlOPKG2OlQQcw29iTg7M9hv17Ob+fiWmVsQ
         3verKj1A3AHYbsTKxZuy4BbP6durQ+y18qpA1SBbS0fqG9ZgKuW/C23bdZRzA37hWr
         8UAPcWQOiRPQp/55gEvL93Yc5mCoGPeWe4O1YBaHkzoskcrPBnYW+QW/pZWM4GfhBc
         O8eNlxHu7rG3bfrRi1H4pg9R7NIRAazJs67bQVYHUStZlDph5Fc3ueLk2HArbZenkD
         VqODljnNeO3Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Tso <kyletso@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 76/87] USB: typec: tcpm: Add a 30ms room for tPSSourceOn in PR_SWAP
Date:   Tue, 22 Dec 2020 21:20:52 -0500
Message-Id: <20201223022103.2792705-76-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
 drivers/usb/typec/tcpm.c | 2 +-
 include/linux/usb/pd.h   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm.c b/drivers/usb/typec/tcpm.c
index 9c901e3b17472..95e4725eaf3f7 100644
--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -3455,7 +3455,7 @@ static void run_state_machine(struct tcpm_port *port)
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 			break;
 		}
-		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON);
+		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
 		break;
 	case PR_SWAP_SRC_SNK_SINK_ON:
 		tcpm_set_state(port, SNK_STARTUP, 0);
diff --git a/include/linux/usb/pd.h b/include/linux/usb/pd.h
index bdf4c88d2aa0a..1a29a7351fbed 100644
--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -441,6 +441,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_DRP_SRC		30
 #define PD_T_PS_SOURCE_OFF	920
 #define PD_T_PS_SOURCE_ON	480
+#define PD_T_PS_SOURCE_ON_PRS	450	/* 390 - 480ms */
 #define PD_T_PS_HARD_RESET	30
 #define PD_T_SRC_RECOVER	760
 #define PD_T_SRC_RECOVER_MAX	1000
-- 
2.27.0

