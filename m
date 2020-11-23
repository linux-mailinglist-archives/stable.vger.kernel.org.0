Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C205F2C07D2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgKWMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733231AbgKWMob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12AC020732;
        Mon, 23 Nov 2020 12:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135469;
        bh=kKXZX2ODAa88tspJibimli222jHvwrgtrR400lzI3fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdzdu0aSX2qFn+Lw1XcBXZyRXLC2qCcUU9d1gbYxMNuQLY1mIQkPCuN/Nwk3qJLTR
         jEnJge13Vx93I8ph0exOeTWHT8dxJytiAYJ0iFz+tU+6CKe89tSuWIbkaRRd/POjck
         3AhrtdRpQXJcGtg7VGsww0Y/eWGOj9yvZEZ8HbJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 050/252] bnxt_en: Free port stats during firmware reset.
Date:   Mon, 23 Nov 2020 13:20:00 +0100
Message-Id: <20201123121838.004368158@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit eba93de6d31c1734dee59909020a162de612e41e ]

Firmware is unable to retain the port counters during any kind of
fatal or non-fatal resets, so we must clear the port counters to
avoid false detection of port counter overflow.

Fixes: fea6b3335527 ("bnxt_en: Accumulate all counters.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4045,7 +4045,8 @@ static void bnxt_free_mem(struct bnxt *b
 	bnxt_free_ntp_fltrs(bp, irq_re_init);
 	if (irq_re_init) {
 		bnxt_free_ring_stats(bp);
-		if (!(bp->fw_cap & BNXT_FW_CAP_PORT_STATS_NO_RESET))
+		if (!(bp->fw_cap & BNXT_FW_CAP_PORT_STATS_NO_RESET) ||
+		    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 			bnxt_free_port_stats(bp);
 		bnxt_free_ring_grps(bp);
 		bnxt_free_vnics(bp);


