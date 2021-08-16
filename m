Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39403ED600
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbhHPNQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237201AbhHPNNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00F7632C3;
        Mon, 16 Aug 2021 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119452;
        bh=7f9NjizwJMB1J72+Q0FTN6bcRclm6hj8r3EYq3EQ5yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kl0nMEBeoOvfgmV9ocApLtpSh9iHGZLQBo2NhkcP2XYd7vXC7mactm4Sj4RTrKisE
         MdVi9DkcUFPHw7CCxgDkQ59ZoBfkbzpT9N40CaMoYmIbMPslOTTSIUpuFy/Pz9P3FE
         c+IQCXJNv3oSdy8+ux+zJWK6D0zN++NNx6ea75Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xu, Terrence" <terrence.xu@intel.com>,
        "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        "Ekstrand, Jason" <jason.ekstrand@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.13 032/151] drm/i915/gvt: Fix cached atomics setting for Windows VM
Date:   Mon, 16 Aug 2021 15:01:02 +0200
Message-Id: <20210816125445.135437560@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 699aa57b35672c3b2f230e2b7e5d0ab8c2bde80a upstream.

We've seen recent regression with host and windows VM running
simultaneously that cause gpu hang or even crash. Finally bisect to
commit 58586680ffad ("drm/i915: Disable atomics in L3 for gen9"),
which seems cached atomics behavior difference caused regression
issue.

This tries to add new scratch register handler and add those in mmio
save/restore list for context switch. No gpu hang produced with this one.

Cc: stable@vger.kernel.org # 5.12+
Cc: "Xu, Terrence" <terrence.xu@intel.com>
Cc: "Bloomfield, Jon" <jon.bloomfield@intel.com>
Cc: "Ekstrand, Jason" <jason.ekstrand@intel.com>
Reviewed-by: Colin Xu <colin.xu@intel.com>
Fixes: 58586680ffad ("drm/i915: Disable atomics in L3 for gen9")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210806044056.648016-1-zhenyuw@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c     |    1 +
 drivers/gpu/drm/i915/gvt/mmio_context.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3149,6 +3149,7 @@ static int init_bdw_mmio_info(struct int
 	MMIO_DFH(_MMIO(0xb100), D_BDW, F_CMD_ACCESS, NULL, NULL);
 	MMIO_DFH(_MMIO(0xb10c), D_BDW, F_CMD_ACCESS, NULL, NULL);
 	MMIO_D(_MMIO(0xb110), D_BDW);
+	MMIO_D(GEN9_SCRATCH_LNCF1, D_BDW_PLUS);
 
 	MMIO_F(_MMIO(0x24d0), 48, F_CMD_ACCESS | F_CMD_WRITE_PATCH, 0, 0,
 		D_BDW_PLUS, NULL, force_nonpriv_write);
--- a/drivers/gpu/drm/i915/gvt/mmio_context.c
+++ b/drivers/gpu/drm/i915/gvt/mmio_context.c
@@ -105,6 +105,8 @@ static struct engine_mmio gen9_engine_mm
 	{RCS0, COMMON_SLICE_CHICKEN2, 0xffff, true}, /* 0x7014 */
 	{RCS0, GEN9_CS_DEBUG_MODE1, 0xffff, false}, /* 0x20ec */
 	{RCS0, GEN8_L3SQCREG4, 0, false}, /* 0xb118 */
+	{RCS0, GEN9_SCRATCH1, 0, false}, /* 0xb11c */
+	{RCS0, GEN9_SCRATCH_LNCF1, 0, false}, /* 0xb008 */
 	{RCS0, GEN7_HALF_SLICE_CHICKEN1, 0xffff, true}, /* 0xe100 */
 	{RCS0, HALF_SLICE_CHICKEN2, 0xffff, true}, /* 0xe180 */
 	{RCS0, HALF_SLICE_CHICKEN3, 0xffff, true}, /* 0xe184 */


