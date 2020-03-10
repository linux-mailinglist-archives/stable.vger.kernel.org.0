Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0102E17F918
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgCJMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgCJMxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A721F24693;
        Tue, 10 Mar 2020 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844832;
        bh=4hrdHfoIQUhu4/00gDb8c5cMXC+cJiqw4UewioJaDP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnfFL9zlBJ2rpxUkmeyOrZjzVJzinH28XQ0xVuwBA77JzKRk4Qjvpcrr8pn5/L3xk
         NMrcbRgsYrBf96iLh2FBUshAgOcQw5b++6PCtK2SWRkc9oydVfa7j5dGdS/4ArnSHr
         Yfi59Lqd2x2ekQMOUDKgF3g6Y4NnAssNmjFPsriQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 135/168] drm/i915: Program MBUS with rmw during initialization
Date:   Tue, 10 Mar 2020 13:39:41 +0100
Message-Id: <20200310123649.176075935@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit c725161924f9a5872a3e53b73345a6026a5c170e upstream.

It wasn't terribly clear from the bspec's wording, but after discussion
with the hardware folks, it turns out that we need to preserve the
pre-existing contents of the MBUS ABOX control register when
initializing a few specific bits.

Bspec: 49213
Bspec: 50096
Fixes: 4cb4585e5a7f ("drm/i915/icl: initialize MBus during display init")
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200204011032.582737-1-matthew.d.roper@intel.com
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
(cherry picked from commit 837b63e6087838d0f1e612d448405419199d8033)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200228004320.127142-1-matthew.d.roper@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display_power.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4205,13 +4205,19 @@ static void icl_dbuf_disable(struct drm_
 
 static void icl_mbus_init(struct drm_i915_private *dev_priv)
 {
-	u32 val;
+	u32 mask, val;
 
-	val = MBUS_ABOX_BT_CREDIT_POOL1(16) |
-	      MBUS_ABOX_BT_CREDIT_POOL2(16) |
-	      MBUS_ABOX_B_CREDIT(1) |
-	      MBUS_ABOX_BW_CREDIT(1);
+	mask = MBUS_ABOX_BT_CREDIT_POOL1_MASK |
+		MBUS_ABOX_BT_CREDIT_POOL2_MASK |
+		MBUS_ABOX_B_CREDIT_MASK |
+		MBUS_ABOX_BW_CREDIT_MASK;
 
+	val = I915_READ(MBUS_ABOX_CTL);
+	val &= ~mask;
+	val |= MBUS_ABOX_BT_CREDIT_POOL1(16) |
+		MBUS_ABOX_BT_CREDIT_POOL2(16) |
+		MBUS_ABOX_B_CREDIT(1) |
+		MBUS_ABOX_BW_CREDIT(1);
 	I915_WRITE(MBUS_ABOX_CTL, val);
 }
 


