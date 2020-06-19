Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6058C20149B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404356AbgFSQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388948AbgFSPEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE92821941;
        Fri, 19 Jun 2020 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579052;
        bh=IZYrfs19SgeWWLKJuBShuVZ/GQEjl9mIxuLz473p+Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2ifCGOj1+bLUdIeoNUJJai7cEuB1ZhaEdKzg7F0b9n4Dzk/EiSRH+AuiFGIvw+t0
         gdbnDSOqiUtXuys0MoApGW7//2qMF88u2Jhx0TEyYAX+/UY4kl510V5QFeBlcvd/99
         9yrRB2ewChEcGTChxDvouY/hpSQfnbC+DZCMBS+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.19 250/267] kernel/cpu_pm: Fix uninitted local in cpu_pm
Date:   Fri, 19 Jun 2020 16:33:55 +0200
Message-Id: <20200619141700.670764597@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit b5945214b76a1f22929481724ffd448000ede914 upstream.

cpu_pm_notify() is basically a wrapper of notifier_call_chain().
notifier_call_chain() doesn't initialize *nr_calls to 0 before it
starts incrementing it--presumably it's up to the callers to do this.

Unfortunately the callers of cpu_pm_notify() don't init *nr_calls.
This potentially means you could get too many or two few calls to
CPU_PM_ENTER_FAILED or CPU_CLUSTER_PM_ENTER_FAILED depending on the
luck of the stack.

Let's fix this.

Fixes: ab10023e0088 ("cpu_pm: Add cpu power management notifiers")
Cc: stable@vger.kernel.org
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200504104917.v6.3.I2d44fc0053d019f239527a4e5829416714b7e299@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpu_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_unregister_noti
  */
 int cpu_pm_enter(void)
 {
-	int nr_calls;
+	int nr_calls = 0;
 	int ret = 0;
 
 	ret = cpu_pm_notify(CPU_PM_ENTER, -1, &nr_calls);
@@ -140,7 +140,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_exit);
  */
 int cpu_cluster_pm_enter(void)
 {
-	int nr_calls;
+	int nr_calls = 0;
 	int ret = 0;
 
 	ret = cpu_pm_notify(CPU_CLUSTER_PM_ENTER, -1, &nr_calls);


