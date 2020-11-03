Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CA22A57B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbgKCUwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732137AbgKCUwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2952B2236F;
        Tue,  3 Nov 2020 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436763;
        bh=mM9p67JparyPNl0jBq+FJskXxSCBycxRnaITaoh7xgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUijQ7oUPq0XGeBsKXd+bKsiyXtfhTo8dvC4ACl+YjJpbAAWiBHiIJWg7cUl7h95V
         n4pPeUgQO9k+S9icyTkvvIEfFORU6pFF7yuaGmAi7zhaADZ+PaDBZlGZ95wykHIvuO
         nSXWpYbQcm0B8rbHP8FoDedH6XrU+Ww0kh8+lEfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 385/391] cpufreq: Introduce cpufreq_driver_test_flags()
Date:   Tue,  3 Nov 2020 21:37:16 +0100
Message-Id: <20201103203413.141104074@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a62f68f5ca53ab61cba2f0a410d0add7a6d54a52 upstream.

Add a helper function to test the flags of the cpufreq driver in use
againt a given flags mask.

In particular, this will be needed to test the
CPUFREQ_NEED_UPDATE_LIMITS cpufreq driver flag in the schedutil
governor.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   12 ++++++++++++
 include/linux/cpufreq.h   |    1 +
 2 files changed, 13 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1904,6 +1904,18 @@ void cpufreq_resume(void)
 }
 
 /**
+ * cpufreq_driver_test_flags - Test cpufreq driver's flags against given ones.
+ * @flags: Flags to test against the current cpufreq driver's flags.
+ *
+ * Assumes that the driver is there, so callers must ensure that this is the
+ * case.
+ */
+bool cpufreq_driver_test_flags(u16 flags)
+{
+	return !!(cpufreq_driver->flags & flags);
+}
+
+/**
  *	cpufreq_get_current_driver - return current driver's name
  *
  *	Return the name string of the currently loaded cpufreq driver
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -428,6 +428,7 @@ struct cpufreq_driver {
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
+bool cpufreq_driver_test_flags(u16 flags);
 const char *cpufreq_get_current_driver(void);
 void *cpufreq_get_driver_data(void);
 


