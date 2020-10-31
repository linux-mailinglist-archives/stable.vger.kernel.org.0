Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D26F2A1678
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgJaLpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgJaLpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9211820791;
        Sat, 31 Oct 2020 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144752;
        bh=n20i3zWYWsM6I4cieIBnFmKekYCK3XMlEXXAdu2hRXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6qsGQ8CN0f2zhzI+miuwt0h6rPAGN7Lz6vaX0vw+inFPQPNa0RwOdwXPF5pAAZU6
         ScOWRwdIzPLEyUw3QaUQFtqI6GLHrdEethkXCBFMYatXlEI0T4zd3C/+hHsqQmeOr+
         +ikgFoHjIs8tvxnjBRQuYAm5S/qxNEFK139nLZsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 68/74] PM: runtime: Fix timer_expires data type on 32-bit arches
Date:   Sat, 31 Oct 2020 12:36:50 +0100
Message-Id: <20201031113503.288620440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 6b61d49a55796dbbc479eeb4465e59fd656c719c upstream.

Commit 8234f6734c5d ("PM-runtime: Switch autosuspend over to using
hrtimers") switched PM runtime autosuspend to use hrtimers and all
related time accounting in ns, but missed to update the timer_expires
data type in struct dev_pm_info to u64.

This causes the timer_expires value to be truncated on 32-bit
architectures when assignment is done from u64 values:

rpm_suspend()
|- dev->power.timer_expires = expires;

Fix it by changing the timer_expires type to u64.

Fixes: 8234f6734c5d ("PM-runtime: Switch autosuspend over to using hrtimers")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: 5.0+ <stable@vger.kernel.org> # 5.0+
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -590,7 +590,7 @@ struct dev_pm_info {
 #endif
 #ifdef CONFIG_PM
 	struct hrtimer		suspend_timer;
-	unsigned long		timer_expires;
+	u64			timer_expires;
 	struct work_struct	work;
 	wait_queue_head_t	wait_queue;
 	struct wake_irq		*wakeirq;


