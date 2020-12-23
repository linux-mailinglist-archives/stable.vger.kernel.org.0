Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D842E14D3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgLWCoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbgLWCWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F42A22A99;
        Wed, 23 Dec 2020 02:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690156;
        bh=70J+aBobIR4CTICimnNAgLI1F8pKSO0ZZzo/AfAcl3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2y1Lmd5lyFOP6pszpCyIhyVRgxXMbqSF5q0i/C/1b4X+fmi7suWljYRwfk2iLivV
         vRDsn71ggl0vsS7IQBgGc41yDIBpQay7ygsyXKrUZXGbZfpGdxWhcs/vqA3JR3IqUv
         WZFnAQgXiM+zYrQIihZSci3kRubD6RlFxusmDl5Fe5ip8fpgDsucUwCZH2o4VAJ0De
         znDcJP9Ruo6io61jAJ2F43pm3bh75MvNCl5hNjLtPQu0f7+FfqyPiNnnPDMc6Xe+Iy
         DJAIw1PTIIDQYjr9pTUM/mOIlnIIjB1eNxBtXuLP6R6PFSFDwylw1yiAXV4UOKT2CZ
         P9tZue8pgmI/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Tso <kyletso@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 75/87] USB: typec: tcpm: Fix PR_SWAP error handling
Date:   Tue, 22 Dec 2020 21:20:51 -0500
Message-Id: <20201223022103.2792705-75-sashal@kernel.org>
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
 drivers/usb/typec/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm.c b/drivers/usb/typec/tcpm.c
index af41d4dce3adb..9c901e3b17472 100644
--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -3455,7 +3455,7 @@ static void run_state_machine(struct tcpm_port *port)
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

