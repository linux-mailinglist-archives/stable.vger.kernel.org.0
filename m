Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A37373A73
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhEEMKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhEEMJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECEA613CD;
        Wed,  5 May 2021 12:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216538;
        bh=Ca6W+aWqY7CdwOH70Dd/4WIBtMWVv/5oI77mQKwWAck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rv3gBt8GylvgNowt0ci6Okjf9w3odJzXnrZ4Furj6OyARMQT48q+9O1D1S1+BTf2
         OWsQvCan+fKVNYt0n7XOLFnXOVgsYXQqIxGfzF8q7e85UVQjlToWCkMjiIRtbWWXWy
         Z4EZxMcoQ9bbOY0rDu6sXWOHtVZ8FNi3EUerKgbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Khaled Almahallawy <khaled.almahallawy@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.11 04/31] drm/i915: Disable runtime power management during shutdown
Date:   Wed,  5 May 2021 14:05:53 +0200
Message-Id: <20210505112326.813820790@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 7962893ecb853aa7c8925ce237ab6c4274cfc1c7 upstream.

At least on some TGL platforms PUNIT wants to access some display HW
registers, but it doesn't handle display power management (disabling DC
states as required) and so this register access will lead to a hang. To
prevent this disable runtime power management for poweroff and reboot.

v2:
- Add code comment clarifying the requirement of display power states.
  (Ville)

Reported-and-tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210127181909.128094-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_drv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1048,6 +1048,8 @@ static void intel_shutdown_encoders(stru
 void i915_driver_shutdown(struct drm_i915_private *i915)
 {
 	disable_rpm_wakeref_asserts(&i915->runtime_pm);
+	intel_runtime_pm_disable(&i915->runtime_pm);
+	intel_power_domains_disable(i915);
 
 	i915_gem_suspend(i915);
 
@@ -1063,7 +1065,15 @@ void i915_driver_shutdown(struct drm_i91
 	intel_suspend_encoders(i915);
 	intel_shutdown_encoders(i915);
 
+	/*
+	 * The only requirement is to reboot with display DC states disabled,
+	 * for now leaving all display power wells in the INIT power domain
+	 * enabled matching the driver reload sequence.
+	 */
+	intel_power_domains_driver_remove(i915);
 	enable_rpm_wakeref_asserts(&i915->runtime_pm);
+
+	intel_runtime_pm_driver_release(&i915->runtime_pm);
 }
 
 static bool suspend_to_idle(struct drm_i915_private *dev_priv)


