Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74662E140B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgLWChm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbgLWCYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 719D322AAF;
        Wed, 23 Dec 2020 02:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690244;
        bh=2baLd7G6FKO3JwsZYeeLATPe/21sVJUcpc//7lAZn5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wf6R/I+8iX4ad8PC2/z9RlC1WXIouJIdeI4AbxJk9izkzdwBcyz8tx9wKNvQxb/Xi
         79MIyEQbFZlOFAhvLJwgPcbxa9oUrpWiqUVjGWp3C0uMfmNJR9FCve16gaH/SKUAJ4
         +sMNDhrB7l9neEn4YVhFoBWZRO0eFOIPou6uIJ7FVY7pLy8idtidijsul9aS4atQBO
         M8tYtu2yoY+OG6lxEiZ2rG+ELmoawcS5wCiNrPU83FvgMv45f7QBUeecCzbALHKYu0
         E2yAroYpZ8RnP5CH6NPw8hA7oFDQyI6YbGLLA3yxw5EQdO/fViT/qxNl9Ua75xX9Ja
         qg1EdYdB0i7bQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Tso <kyletso@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 57/66] USB: typec: tcpm: Fix PR_SWAP error handling
Date:   Tue, 22 Dec 2020 21:22:43 -0500
Message-Id: <20201223022253.2793452-57-sashal@kernel.org>
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

[ Upstream commit 301a633c1b5b2caa4c4b97a83270d4a1d60c53bf ]

PD rev3.0 8.3.3.16.3.6 PE_PRS_SRC_SNK_Wait_Source_on State
The Policy Enging Shall transition to the ErrorRecovery state when the
PSSourceOnTimer times out ...

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20201210160521.3417426-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/typec/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/typec/tcpm.c b/drivers/staging/typec/tcpm.c
index 686037a498c19..39f99a80daf73 100644
--- a/drivers/staging/typec/tcpm.c
+++ b/drivers/staging/typec/tcpm.c
@@ -2710,7 +2710,7 @@ static void run_state_machine(struct tcpm_port *port)
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 			break;
 		}
-		tcpm_set_state_cond(port, SNK_UNATTACHED, PD_T_PS_SOURCE_ON);
+		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON);
 		break;
 	case PR_SWAP_SRC_SNK_SINK_ON:
 		tcpm_set_state(port, SNK_STARTUP, 0);
-- 
2.27.0

