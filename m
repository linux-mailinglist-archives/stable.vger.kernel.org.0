Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E160E2E1409
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgLWChg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgLWCYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3D9022A83;
        Wed, 23 Dec 2020 02:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690246;
        bh=UFGOHJZnX8AwPrZdNDlIgkkbhuOJqGlT3OvDbUNJWOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBZlGNODG15HCxxAkPTgFSMyDvTw1U20Zy5cVGcJufoHVxUcahL4Wdfz3u0FiMUsD
         W2MfFc6ZR5HLD6LDGUaCB5RViR4OtevYqCZRFGGH97dJypizchnIuNN05Sq+PFb5Zo
         qo+6sFpzFXe62dCiwetbKNDzXU8sy8yQyHF66nF15+YVlCplrIVmJvRw1NXWdxcxFO
         3Iai92BFhfIeZQ8vRCk/ycWL9Q1m6N7d4qbYmpENWU+joYpvYES8PwlmK3HNacOPpA
         JrGDtADMxS2O0S2UmSiyD7Icdx3nHVuzD9qZdNixALAiGMJqM4kjbniN78QOxljunq
         J8XC+CMcwj+NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Tso <kyletso@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 58/66] USB: typec: tcpm: Add a 30ms room for tPSSourceOn in PR_SWAP
Date:   Tue, 22 Dec 2020 21:22:44 -0500
Message-Id: <20201223022253.2793452-58-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
 drivers/staging/typec/pd.h   | 1 +
 drivers/staging/typec/tcpm.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/typec/pd.h b/drivers/staging/typec/pd.h
index a18ab898fa668..62766585e2f98 100644
--- a/drivers/staging/typec/pd.h
+++ b/drivers/staging/typec/pd.h
@@ -270,6 +270,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_DRP_SRC		30
 #define PD_T_PS_SOURCE_OFF	920
 #define PD_T_PS_SOURCE_ON	480
+#define PD_T_PS_SOURCE_ON_PRS	450	/* 390 - 480ms */
 #define PD_T_PS_HARD_RESET	30
 #define PD_T_SRC_RECOVER	760
 #define PD_T_SRC_RECOVER_MAX	1000
diff --git a/drivers/staging/typec/tcpm.c b/drivers/staging/typec/tcpm.c
index 39f99a80daf73..3a2a9d0ba720c 100644
--- a/drivers/staging/typec/tcpm.c
+++ b/drivers/staging/typec/tcpm.c
@@ -2710,7 +2710,7 @@ static void run_state_machine(struct tcpm_port *port)
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 			break;
 		}
-		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON);
+		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
 		break;
 	case PR_SWAP_SRC_SNK_SINK_ON:
 		tcpm_set_state(port, SNK_STARTUP, 0);
-- 
2.27.0

