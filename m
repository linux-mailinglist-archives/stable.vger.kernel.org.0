Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0871578A6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgBJMjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbgBJMjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:21 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5435620838;
        Mon, 10 Feb 2020 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338361;
        bh=HNCafts085ILlVpD5iBEx9OslT86d6ijg+8HvRDpaUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLWpq2hxU7UpmT8sBCFK6HIon0ujnfXzNEg8EkssbyzH28JqhXHhMfD/GySILOwGi
         xd2kc+Rl7jpVMcDzBbayKn097yD/hLu4lGYR4yijJ55MWulfiFLcrFsNlYBy2JsDu2
         1xUomejoinq0yNPfjLOuMk0Lx8dA5EzLw8evF1Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.5 022/367] bnxt_en: Fix RDMA driver failure with SRIOV after firmware reset.
Date:   Mon, 10 Feb 2020 04:28:55 -0800
Message-Id: <20200210122425.925120498@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 12de2eadf87825c3990c1aa68b5e93101ca2f043 ]

bnxt_ulp_start() needs to be called before SRIOV is re-enabled after
firmware reset.  Re-enabling SRIOV may consume all the resources and
may cause the RDMA driver to fail to get MSIX and other resources.
Fix it by calling bnxt_ulp_start() first before calling
bnxt_reenable_sriov().

We re-arrange the logic so that we call bnxt_ulp_start() and
bnxt_reenable_sriov() in proper sequence in bnxt_fw_reset_task() and
bnxt_open().  The former is the normal coordinated firmware reset sequence
and the latter is firmware reset while the function is down.  This new
logic is now more straight forward and will now fix both scenarios.

Fixes: f3a6d206c25a ("bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.")
Reported-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9269,9 +9269,10 @@ static int bnxt_open(struct net_device *
 		bnxt_hwrm_if_change(bp, false);
 	} else {
 		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
-			bnxt_reenable_sriov(bp);
-			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 				bnxt_ulp_start(bp, 0);
+				bnxt_reenable_sriov(bp);
+			}
 		}
 		bnxt_hwmon_open(bp);
 	}
@@ -10827,6 +10828,8 @@ static void bnxt_fw_reset_task(struct wo
 		smp_mb__before_atomic();
 		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 		bnxt_ulp_start(bp, rc);
+		if (!rc)
+			bnxt_reenable_sriov(bp);
 		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
 		break;


