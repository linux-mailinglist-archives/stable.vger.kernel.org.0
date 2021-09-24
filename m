Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1B4173B5
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbhIXM7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345451AbhIXM6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3551E61251;
        Fri, 24 Sep 2021 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487944;
        bh=TfoJ2p8dQAMQdgFblQlWh48fZB2Inznd8bBo8f11uZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdfIsdi3IMT4nM6iAckMhLX08eEsaIqAkCcyRX+dt7IokXkKHB+YnK9Ncn04KN7y6
         T/zkAOAoqLL37F25D4xsvJmrXwzkLCvO3N0j62FEriZrgSMwjucKMFTSxQdWUPj/KW
         wOQvXSfTnB1cD9VLCcgJMGERtgG80an+nsCc53SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Sodagudi <psodagud@codeaurora.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.14 022/100] PM: sleep: core: Avoid setting power.must_resume to false
Date:   Fri, 24 Sep 2021 14:43:31 +0200
Message-Id: <20210924124342.177607459@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prasad Sodagudi <psodagud@codeaurora.org>

commit 4a9344cd0aa4499beb3772bbecb40bb78888c0e1 upstream.

There are variables(power.may_skip_resume and dev->power.must_resume)
and DPM_FLAG_MAY_SKIP_RESUME flags to control the resume of devices after
a system wide suspend transition.

Setting the DPM_FLAG_MAY_SKIP_RESUME flag means that the driver allows
its "noirq" and "early" resume callbacks to be skipped if the device
can be left in suspend after a system-wide transition into the working
state. PM core determines that the driver's "noirq" and "early" resume
callbacks should be skipped or not with dev_pm_skip_resume() function by
checking power.may_skip_resume variable.

power.must_resume variable is getting set to false in __device_suspend()
function without checking device's DPM_FLAG_MAY_SKIP_RESUME settings.
In problematic scenario, where all the devices in the suspend_late
stage are successful and some device can fail to suspend in
suspend_noirq phase. So some devices successfully suspended in suspend_late
stage are not getting chance to execute __device_suspend_noirq()
to set dev->power.must_resume variable to true and not getting
resumed in early_resume phase.

Add a check for device's DPM_FLAG_MAY_SKIP_RESUME flag before
setting power.must_resume variable in __device_suspend function.

Fixes: 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the resume phase")
Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1642,7 +1642,7 @@ static int __device_suspend(struct devic
 	}
 
 	dev->power.may_skip_resume = true;
-	dev->power.must_resume = false;
+	dev->power.must_resume = !dev_pm_test_driver_flags(dev, DPM_FLAG_MAY_SKIP_RESUME);
 
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);


