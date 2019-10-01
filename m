Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02147C3E53
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfJAROO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:14:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33828 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfJAROO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:14:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id b128so8483535pfa.1
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 10:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NLLDaVYu08NM6x1THeCxxFZ7SbKZd2dVoqgn+GP8d8w=;
        b=xTxJ1tRCBZW1eKhSkwHjd2DJ/S2KZkBDYpOD9aLvdRaIuP8h3Tm40Th1df2NTkIRqG
         hq56ZLjKWkfPzD7Yf2KCF7ZhqUGarIhLY677cTpMRS4EGuHfYHxFbIRqsf8MaQ682NtR
         DDp7RRM0mHDjsEEJyUwvL1B2TwMJeoNJXRd9GyvS/SM9q4bubiQqQgkHCfjEzPIpLWon
         ewBsgFQBbsgd9Z7Bx2ZuaL2XYDXC0A8CP67N+DdSl1XLCYQ3W+1gc+ph1MsVv8tuq6dO
         faMs0fpIO1bVKlqojdWGsjFD5841EC+zvtY4Kek5Du6wdAw2Y+Tg5abqdb2/1xz/jx09
         2KSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NLLDaVYu08NM6x1THeCxxFZ7SbKZd2dVoqgn+GP8d8w=;
        b=Igo0B3tXA5Z2FbDYWYSRRebecZlu4K6GJ8TT/RdaauDYhCV9vDTJJ0KzZP5/8KD1ZX
         ZCmFRXxiuCDciG88mt7OOpSw0XCedtvL2u2cuodIJ2lD76F8Jqf1O7CP8ZTKRVvUl3u+
         JLHnJmvOM0CNZdFxqJnfwvizN3N+0LxyonxXTv0XeE99SokW1E6lqATv0l0JuXAUUkB4
         6hM/FJX4PVIvb/6YfnFcW6Y8ot6msOH7oy/hVQ/MYHXsuMIDErgkgNay33WZTjtHtDlK
         l128i5Aq1vMgr6qR19O0kbUWT2AqlfBNO0SGCZeejVm7Q9sRA0nBJKclsnb/02nmN+nd
         5c1A==
X-Gm-Message-State: APjAAAVqbPGyzSHUpvdP/o7MxyQu+YCzrr/fd0uWC8xZVwkzTum7Tkez
        xNzuNadGYVzjpVeca3NTWCv+CdO0tm8=
X-Google-Smtp-Source: APXvYqxktyCHg/rgXNWW7VBNcg3rJplLHywKDLlltnrQauDluKkR0Fp9DsVVRYyyVsKLhgG29+rkWA==
X-Received: by 2002:a17:90a:bb8e:: with SMTP id v14mr6497030pjr.84.1569950053127;
        Tue, 01 Oct 2019 10:14:13 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m2sm20387666pff.154.2019.10.01.10.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 10:14:12 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
        andrew.murray@arm.com
Subject: [PATCH] coresight: etm4x: Use explicit barriers on enable/disable
Date:   Tue,  1 Oct 2019 11:14:11 -0600
Message-Id: <20191001171411.16602-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

commit 1004ce4c255fc3eb3ad9145ddd53547d1b7ce327 upstream

Synchronization is recommended before disabling the trace registers
to prevent any start or stop points being speculative at the point
of disabling the unit (section 7.3.77 of ARM IHI 0064D).

Synchronization is also recommended after programming the trace
registers to ensure all updates are committed prior to normal code
resuming (section 4.3.7 of ARM IHI 0064D).

Let's ensure these syncronization points are present in the code
and clearly commented.

Note that we could rely on the barriers in CS_LOCK and
coresight_disclaim_device_unlocked or the context switch to user
space - however coresight may be of use in the kernel.

On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
only used on armv8 let's directly use dsb(sy) instead of mb(). This
removes some ambiguity and makes it easier to correlate the code with
the TRM.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Fixed capital letter for "use" in title]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190829202842.580-11-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index da27f8edba50..44d6c29e2644 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -181,6 +181,12 @@ static void etm4_enable_hw(void *info)
 	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 0))
 		dev_err(drvdata->dev,
 			"timeout while waiting for Idle Trace Status\n");
+	/*
+	 * As recommended by section 4.3.7 ("Synchronization when using the
+	 * memory-mapped interface") of ARM IHI 0064D
+	 */
+	dsb(sy);
+	isb();
 
 	CS_LOCK(drvdata->base);
 
@@ -323,8 +329,12 @@ static void etm4_disable_hw(void *info)
 	/* EN, bit[0] Trace unit enable bit */
 	control &= ~0x1;
 
-	/* make sure everything completes before disabling */
-	mb();
+	/*
+	 * Make sure everything completes before disabling, as recommended
+	 * by section 7.3.77 ("TRCVICTLR, ViewInst Main Control Register,
+	 * SSTATUS") of ARM IHI 0064D
+	 */
+	dsb(sy);
 	isb();
 	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
 
-- 
2.17.1

