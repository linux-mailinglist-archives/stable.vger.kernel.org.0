Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1D62C0A2A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388846AbgKWNRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732947AbgKWMmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C025E20857;
        Mon, 23 Nov 2020 12:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135355;
        bh=6g76o2F+FbIGM89xfWcvN/UJw/qeZchtFzipodfoOmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDQg2ltVs7pi9FpgOtwl47wmDkLNCX6FzAyGql/Wsv2wjp5kLnss61kRgorcUSA7y
         wp7uy6yuhiyB9D++CPnGgrU9h+fUCl9m1FZ/zcVVeJ94wyjNvR6abZ2r0clQDe76hW
         kYBjWh2WN/mKIa9rCFkUqPRw5W8JAPbNZYcGgLyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 038/252] qed: fix ILT configuration of SRC block
Date:   Mon, 23 Nov 2020 13:19:48 +0100
Message-Id: <20201123121837.423094705@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 93be52612431e71ee8cb980ef11468997857e4c4 ]

The code refactoring of ILT configuration was not complete, the old
unused variables were used for the SRC block. That could lead to the memory
corruption by HW when rx filters are configured.
This patch completes that refactoring.

Fixes: 8a52bbab39c9 (qed: Debug feature: ilt and mdump)
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Link: https://lore.kernel.org/r/20201116132944.2055-1-dbogdanov@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c |    4 ++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1647,9 +1647,9 @@ static void qed_src_init_pf(struct qed_h
 		     ilog2(rounded_conn_num));
 
 	STORE_RT_REG_AGG(p_hwfn, SRC_REG_FIRSTFREE_RT_OFFSET,
-			 p_hwfn->p_cxt_mngr->first_free);
+			 p_hwfn->p_cxt_mngr->src_t2.first_free);
 	STORE_RT_REG_AGG(p_hwfn, SRC_REG_LASTFREE_RT_OFFSET,
-			 p_hwfn->p_cxt_mngr->last_free);
+			 p_hwfn->p_cxt_mngr->src_t2.last_free);
 }
 
 /* Timers PF */
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -326,9 +326,6 @@ struct qed_cxt_mngr {
 
 	/* SRC T2 */
 	struct qed_src_t2 src_t2;
-	u32 t2_num_pages;
-	u64 first_free;
-	u64 last_free;
 
 	/* total number of SRQ's for this hwfn */
 	u32 srq_count;


