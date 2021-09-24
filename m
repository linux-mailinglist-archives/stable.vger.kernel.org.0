Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28074174A6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346253AbhIXNJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345764AbhIXNHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9F761260;
        Fri, 24 Sep 2021 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488205;
        bh=N20MLf36DgCPu5d6xWGURqHVe4zsJzisTII6DkueNnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeClcsTHxQzhi2PkUTeFKhW3/6Q6QE098IEfk+pMoszAEcenLOV/v9Sx8PA3ka6xY
         Qo0tZDrkPXMf51l5wcgsaU97GO1b63/yh6v17NjZdaREWdyfp7/A4OD14rH8xotStt
         E0SKS6c2RLHxj9p7U2BJkFLlhpUfV8pIRqJgR9CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Sodagudi <psodagud@codeaurora.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 24/63] PM: sleep: core: Avoid setting power.must_resume to false
Date:   Fri, 24 Sep 2021 14:44:24 +0200
Message-Id: <20210924124335.095797975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
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
@@ -1644,7 +1644,7 @@ static int __device_suspend(struct devic
 	}
 
 	dev->power.may_skip_resume = true;
-	dev->power.must_resume = false;
+	dev->power.must_resume = !dev_pm_test_driver_flags(dev, DPM_FLAG_MAY_SKIP_RESUME);
 
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);


