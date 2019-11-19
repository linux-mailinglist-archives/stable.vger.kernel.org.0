Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5605210190A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfKSFWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbfKSFWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F80A21939;
        Tue, 19 Nov 2019 05:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140943;
        bh=KgLFUxqiQqCPOgQl8/HEsbp+YfedIZzmvbyG4jLGpcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5+2qh30e40+uLsmSvIgwdBw2cX59dPwBFu9rHysmlf/pKlTQ9uHNDXcaq0nnZtKI
         OleKwF0fm8J9C2n8KL2lRwE0XpFAIrhcC5GUfe4Ju1STo/aECDPzslGy4QqsftMq/W
         OE1PEemTilxSyjalkCrS559siH35Jv9b9jIgMBPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francisco Jerez <francisco.jerez.plata@intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Francisco Jerez <currojerez@riseup.net>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 38/48] Revert "drm/i915/ehl: Update MOCS table for EHL"
Date:   Tue, 19 Nov 2019 06:19:58 +0100
Message-Id: <20191119051019.893089107@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit ed77d88752aea56b33731aee42e7146379b90769 upstream.

This reverts commit f4071997f1de016780ec6b79c63d90cd5886ee83.

These extra EHL entries won't behave as expected without a bit more work
on the kernel side so let's drop them until that kernel work has had a
chance to land.  Userspace trying to use these new entries won't get the
advantage of the new functionality these entries are meant to provide,
but at least it won't misbehave.

When we do add these back in the future, we'll probably want to
explicitly use separate tables for ICL and EHL so that userspace
software that mistakenly uses these entries (which are undefined on ICL)
sees the same behavior it sees with all the other undefined entries.

Cc: Francisco Jerez <francisco.jerez.plata@intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Fixes: f4071997f1de ("drm/i915/ehl: Update MOCS table for EHL")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191112224757.25116-1-matthew.d.roper@intel.com
Reviewed-by: Francisco Jerez <currojerez@riseup.net>
(cherry picked from commit 046091758b50a5fff79726a31c1391614a3d84c8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_mocs.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -200,14 +200,6 @@ static const struct drm_i915_mocs_entry
 	MOCS_ENTRY(15, \
 		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(2) | LE_AOM(1), \
 		   L3_3_WB), \
-	/* Bypass LLC - Uncached (EHL+) */ \
-	MOCS_ENTRY(16, \
-		   LE_1_UC | LE_TC_1_LLC | LE_SCF(1), \
-		   L3_1_UC), \
-	/* Bypass LLC - L3 (Read-Only) (EHL+) */ \
-	MOCS_ENTRY(17, \
-		   LE_1_UC | LE_TC_1_LLC | LE_SCF(1), \
-		   L3_3_WB), \
 	/* Self-Snoop - L3 + LLC */ \
 	MOCS_ENTRY(18, \
 		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3) | LE_SSE(3), \


