Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99A519908F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgCaJMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731129AbgCaJMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E6DA20675;
        Tue, 31 Mar 2020 09:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645952;
        bh=YY8lLrOB4duBAq0wkTfQHeNzcmgnD93oEjkB30RPVlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3ENi2dokuQ+cZClb/z3N0AKpysqJXwhOHUAPx907HHbL0OsyK31++cTlcZh/kYDa
         +PODuCdHSNvhM+XMAizeWXEJLT8ZVBfkiTLxXpRk94G5+sr0evUKhP92KS9GakRZKy
         vdyNZ4SDt/yIbM6u89HusUhtW4UQjrg4gqWwwJHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 041/155] bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.
Date:   Tue, 31 Mar 2020 10:58:01 +0200
Message-Id: <20200331085423.020114735@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0b5b561cea32d5bb1e0a82d65b755a3cb5212141 ]

The current code ignores the return value from
bnxt_hwrm_func_backing_store_cfg(), causing the driver to proceed in
the init path even when this vital firmware call has failed.  Fix it
by propagating the error code to the caller.

Fixes: 1b9394e5a2ad ("bnxt_en: Configure context memory on new devices.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6863,12 +6863,12 @@ skip_rdma:
 	}
 	ena |= FUNC_BACKING_STORE_CFG_REQ_DFLT_ENABLES;
 	rc = bnxt_hwrm_func_backing_store_cfg(bp, ena);
-	if (rc)
+	if (rc) {
 		netdev_err(bp->dev, "Failed configuring context mem, rc = %d.\n",
 			   rc);
-	else
-		ctx->flags |= BNXT_CTX_FLAG_INITED;
-
+		return rc;
+	}
+	ctx->flags |= BNXT_CTX_FLAG_INITED;
 	return 0;
 }
 


