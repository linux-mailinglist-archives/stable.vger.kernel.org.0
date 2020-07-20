Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8685222680A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbgGTQQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388176AbgGTQQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF53220656;
        Mon, 20 Jul 2020 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261802;
        bh=pQ+eqRO82I54RBC7+dnC80ZO8u1//XIuHLoK2yJpOZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dad8PwmB2pnhgD/PlINGz/9a7g6RvpkdPfDURtP7dIJBF8y1EfXc9vU5MZq58coyQ
         RVweP+rnUy5mKnE5A0yzwNKVRv6RXlAIF6PYHn9Jn/5S2dVjkSASKNm9X9A2WEViFp
         rMTdPC3MXGcpNFm9rQOJN4ozC1LlvqBxRTQenTTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.7 240/244] drm/i915/gvt: Fix two CFL MMIO handling caused by regression.
Date:   Mon, 20 Jul 2020 17:38:31 +0200
Message-Id: <20200720152837.253689680@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -3131,8 +3131,8 @@ static int init_skl_mmio_info(struct int
 	MMIO_DFH(GEN9_WM_CHICKEN3, D_SKL_PLUS, F_MODE_MASK | F_CMD_ACCESS,
 		 NULL, NULL);
 
-	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL);
-	MMIO_D(GEN9_CTX_PREEMPT_REG, D_KBL | D_SKL);
+	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL | D_CFL);
+	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS);
 
 	return 0;
 }


