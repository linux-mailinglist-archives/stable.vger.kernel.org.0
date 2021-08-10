Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3463E8083
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhHJRup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhHJRr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E1961075;
        Tue, 10 Aug 2021 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617270;
        bh=fQOstmbRlspXSogWLL7VNXQJHjnMFUIAHB4Xgmwa3yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCVFbZsCnYGyvy/aZITicyGNIYPh7ZdXJsDqicvGMsR67S/PG2a+nvsFd3ezJRsue
         bGZ1KmRlfitrbMj7k2rCddSAnXfDjYVxHQ/S+QuuEqyNqV4t1Pp0Eott7SmRPd18cE
         0vltOOkZP5SQ6jWrkwVXhQt+BRCHh/KGB9zDDqrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.10 121/135] drm/i915: Correct SFC_DONE register offset
Date:   Tue, 10 Aug 2021 19:30:55 +0200
Message-Id: <20210810172959.904639631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 9c9c6d0ab08acfe41c9f7efa72c4ad3f133a266b upstream.

The register offset for SFC_DONE was missing a '0' at the end, causing
us to read from a non-existent register address.  We only use this
register in error state dumps so the mistake hasn't caused any real
problems, but fixing it will hopefully make the error state dumps a bit
more useful for debugging.

Fixes: e50dbdbfd9fb ("drm/i915/tgl: Add SFC instdone to error state")
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210728233411.2365788-1-matthew.d.roper@intel.com
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
(cherry picked from commit 82929a2140eb99f1f1d21855f3f580e70d7abdd8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -413,7 +413,7 @@ static inline bool i915_mmio_reg_valid(i
 #define GEN11_VECS_SFC_USAGE(engine)		_MMIO((engine)->mmio_base + 0x2014)
 #define   GEN11_VECS_SFC_USAGE_BIT		(1 << 0)
 
-#define GEN12_SFC_DONE(n)		_MMIO(0x1cc00 + (n) * 0x100)
+#define GEN12_SFC_DONE(n)		_MMIO(0x1cc000 + (n) * 0x1000)
 #define GEN12_SFC_DONE_MAX		4
 
 #define RING_PP_DIR_BASE(base)		_MMIO((base) + 0x228)


