Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352D412EC4F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgABWRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbgABWRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75BA521582;
        Thu,  2 Jan 2020 22:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003432;
        bh=6gg8n245oKU6viEJFYY+Mla3YUq8ygLK2YyYWrBCq1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lu+B1C9EClHWHzRki/5HXpjr1Luptwk1CZ7SOcwI7LZhUnUyqSPBwLj41eBNwrKBz
         WhtaVe8UXBT+qblwSzo7AFlnyVOS5aZiyv1edfvSzaIAeoZoCwfa8v1GKRjhYKKYh+
         8RSko/3GoHbbma+FEvzhaCRF/2/LJ1MxfyUxEj2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 159/191] bnxt_en: Free context memory in the open path if firmware has been reset.
Date:   Thu,  2 Jan 2020 23:07:21 +0100
Message-Id: <20200102215846.425151646@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 325f85f37e5b35807d86185bdf2c64d2980c44ba ]

This will trigger new context memory to be rediscovered and allocated
during the re-probe process after a firmware reset.  Without this, the
newly reset firmware does not have valid context memory and the driver
will eventually fail to allocate some resources.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8766,6 +8766,9 @@ static int bnxt_hwrm_if_change(struct bn
 	}
 	if (resc_reinit || fw_reset) {
 		if (fw_reset) {
+			bnxt_free_ctx_mem(bp);
+			kfree(bp->ctx);
+			bp->ctx = NULL;
 			rc = bnxt_fw_init_one(bp);
 			if (rc) {
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);


