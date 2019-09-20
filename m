Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E42B932C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbfITOY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35610 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728946AbfITOY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqB-0004vz-Sx; Fri, 20 Sep 2019 15:24:55 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqB-0007pA-3P; Fri, 20 Sep 2019 15:24:55 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "=?UTF-8?q?Christoph=20Vogtl=C3=A4nder?=" 
        <c.vogtlaender@sigma-surface-science.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.431807513@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 008/132] pwm: tiehrpwm: Update shadow register for
 disabling PWMs
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Vogtländer
 <c.vogtlaender@sigma-surface-science.com>

commit b00ef53053191d3025c15e8041699f8c9d132daf upstream.

It must be made sure that immediate mode is not already set, when
modifying shadow register value in ehrpwm_pwm_disable(). Otherwise
modifications to the action-qualifier continuous S/W force
register(AQSFRC) will be done in the active register.
This may happen when both channels are being disabled. In this case,
only the first channel state will be recorded as disabled in the shadow
register. Later, when enabling the first channel again, the second
channel would be enabled as well. Setting RLDCSF to zero, first, ensures
that the shadow register is updated as desired.

Fixes: 38dabd91ff0b ("pwm: tiehrpwm: Fix disabling of output of PWMs")
Signed-off-by: Christoph Vogtländer <c.vogtlaender@sigma-surface-science.com>
[vigneshr@ti.com: Improve commit message]
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pwm/pwm-tiehrpwm.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -379,6 +379,8 @@ static void ehrpwm_pwm_disable(struct pw
 	}
 
 	/* Update shadow register first before modifying active register */
+	ehrpwm_modify(pc->mmio_base, AQSFRC, AQSFRC_RLDCSF_MASK,
+		      AQSFRC_RLDCSF_ZRO);
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 	/*
 	 * Changes to immediate action on Action Qualifier. This puts

