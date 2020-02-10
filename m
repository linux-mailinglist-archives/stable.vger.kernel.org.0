Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534D21578FC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgBJNLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgBJMi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365C82080C;
        Mon, 10 Feb 2020 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338336;
        bh=mXgJDsvXcMB4V3q6nk9hNA+TUE92NqmQrxhg8xXFQ8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4HBYykEpA7CAQ8CtLT64hRhi+cXDEvnx/ZqBlgvf36PXoFQanAyAcvliHnBDMIKK
         6521gxYywDN8ihpAJKMETWyNKzKedcjyr0iGWuqKQ58ZWlGMf7bvaIrGWxlJC77aWb
         BC8x/XnDFtvplJOr1Y/fGLx0UrZUx0xdQPm/9nyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 283/309] qed: Fix timestamping issue for L2 unicast ptp packets.
Date:   Mon, 10 Feb 2020 04:33:59 -0800
Message-Id: <20200210122433.833746118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit 0202d293c2faecba791ba4afc5aec086249c393d ]

commit cedeac9df4b8 ("qed: Add support for Timestamping the unicast
PTP packets.") handles the timestamping of L4 ptp packets only.
This patch adds driver changes to detect/timestamp both L2/L4 unicast
PTP packets.

Fixes: cedeac9df4b8 ("qed: Add support for Timestamping the unicast PTP packets.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -44,8 +44,8 @@
 /* Add/subtract the Adjustment_Value when making a Drift adjustment */
 #define QED_DRIFT_CNTR_DIRECTION_SHIFT		31
 #define QED_TIMESTAMP_MASK			BIT(16)
-/* Param mask for Hardware to detect/timestamp the unicast PTP packets */
-#define QED_PTP_UCAST_PARAM_MASK		0xF
+/* Param mask for Hardware to detect/timestamp the L2/L4 unicast PTP packets */
+#define QED_PTP_UCAST_PARAM_MASK              0x70F
 
 static enum qed_resc_lock qed_ptcdev_to_resc(struct qed_hwfn *p_hwfn)
 {


