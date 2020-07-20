Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C642266AA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732950AbgGTQFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732365AbgGTQFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AC92064B;
        Mon, 20 Jul 2020 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261112;
        bh=IufbSqnQoO/XlYrV0tWMAZ9tLze7G+NS2wb+k+R0EUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndTurylZXonI5tpV4fcKpzgb8h1/52/2vWvP4/xlD46BhEuSRGOTS8VX2Zk3IutAH
         abvVkjP9Uaztb8yQmn6h39B9eQEnzFkFnqdhHRiabbj8/Gc8WuObvoHcSBztOWqr8d
         bASZXBP1HO5R4S2muT9pUw3jTqUqnkG5Ay78edJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.4 214/215] drm/i915/gvt: Fix two CFL MMIO handling caused by regression.
Date:   Mon, 20 Jul 2020 17:38:16 +0200
Message-Id: <20200720152830.328049538@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

commit fccd0f7cf4d532674d727c7f204f038456675dee upstream.

D_CFL was incorrectly removed for:
GAMT_CHKN_BIT_REG
GEN9_CTX_PREEMPT_REG

V2: Update commit message.
V3: Rebase and split Fixes and mis-handled MMIO.

Fixes: 43226e6fe798 (drm/i915/gvt: replaced register address with name)
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200601030638.16002-1-colin.xu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/handlers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3103,8 +3103,8 @@ static int init_skl_mmio_info(struct int
 	MMIO_DFH(GEN9_WM_CHICKEN3, D_SKL_PLUS, F_MODE_MASK | F_CMD_ACCESS,
 		 NULL, NULL);
 
-	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL);
-	MMIO_D(GEN9_CTX_PREEMPT_REG, D_KBL | D_SKL);
+	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL | D_CFL);
+	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS);
 
 	return 0;
 }


