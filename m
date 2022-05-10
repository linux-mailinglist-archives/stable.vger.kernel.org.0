Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82455218DF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbiEJNlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245095AbiEJNia (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06112380F0;
        Tue, 10 May 2022 06:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343BE61765;
        Tue, 10 May 2022 13:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F10C385A6;
        Tue, 10 May 2022 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189223;
        bh=gtbfH+T5AoOjAbd4/m5ZRqSJUdNdOLZiOe36gKOgnjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agp/VSysortu0V2oEzEOSB9lKLpy+oUtyg7WGeC2MTtpOpxtYRcrEB8vmFKvGvoWT
         lGcpFHmnHU9f7B8yceZ/RTOA6qZss1L66LjbT24KZomJ9gGcbu2Nqg89hHEr/fgaV2
         aZWu+o2GYkTu1uVAsEw+wCvb9jLnZTVWDfjc/++o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 52/70] bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag
Date:   Tue, 10 May 2022 15:08:11 +0200
Message-Id: <20220510130734.385248355@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

commit 13ba794397e45e52893cfc21d7a69cb5f341b407 upstream.

bnxt_open() can fail in this code path, especially on a VF when
it fails to reserve default rings:

bnxt_open()
  __bnxt_open_nic()
    bnxt_clear_int_mode()
    bnxt_init_dflt_ring_mode()

RX rings would be set to 0 when we hit this error path.

It is possible for a subsequent bnxt_open() call to potentially succeed
with a code path like this:

bnxt_open()
  bnxt_hwrm_if_change()
    bnxt_fw_init_one()
      bnxt_fw_init_one_p3()
        bnxt_set_dflt_rfs()
          bnxt_rfs_capable()
            bnxt_hwrm_reserve_rings()

On older chips, RFS is capable if we can reserve the number of vnics that
is equal to RX rings + 1.  But since RX rings is still set to 0 in this
code path, we may mistakenly think that RFS is supported for 0 RX rings.

Later, when the default RX rings are reserved and we try to enable
RFS, it would fail and cause bnxt_open() to fail unnecessarily.

We fix this in 2 places.  bnxt_rfs_capable() will always return false if
RX rings is not yet set.  bnxt_init_dflt_ring_mode() will call
bnxt_set_dflt_rfs() which will always clear the RFS flags if RFS is not
supported.

Fixes: 20d7d1c5c9b1 ("bnxt_en: reliably allocate IRQ table on reset to avoid crash")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10453,7 +10453,7 @@ static bool bnxt_rfs_capable(struct bnxt
 
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
 		return bnxt_rfs_supported(bp);
-	if (!(bp->flags & BNXT_FLAG_MSIX_CAP) || !bnxt_can_reserve_rings(bp))
+	if (!(bp->flags & BNXT_FLAG_MSIX_CAP) || !bnxt_can_reserve_rings(bp) || !bp->rx_nr_rings)
 		return false;
 
 	vnics = 1 + bp->rx_nr_rings;
@@ -12481,10 +12481,9 @@ static int bnxt_init_dflt_ring_mode(stru
 		goto init_dflt_ring_err;
 
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
-	if (bnxt_rfs_supported(bp) && bnxt_rfs_capable(bp)) {
-		bp->flags |= BNXT_FLAG_RFS;
-		bp->dev->features |= NETIF_F_NTUPLE;
-	}
+
+	bnxt_set_dflt_rfs(bp);
+
 init_dflt_ring_err:
 	bnxt_ulp_irq_restart(bp, rc);
 	return rc;


