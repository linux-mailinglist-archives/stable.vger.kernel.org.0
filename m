Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7352A16AB
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgJaLrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgJaLpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82A7C205F4;
        Sat, 31 Oct 2020 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144710;
        bh=d/gvzzOu1LqAaNgLogFJEYDew1QFncaqdBQEdDRGy1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LL7j+Ynmk1NC0Y2KlxwunhmxFaE7/cokVXXg3P/WF1dGN02eP1/Yew6mI7Hl8+5LQ
         Mk+BLX7PfCPKfa1AyIw6kNsb0Od8wL957qDf75O9gR3S0i8w1mvczlllDDm2Tdpq9F
         pHbR+Lp+vVbvFh6sTQ6NYyi4c09svH/3SstsVet0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 50/74] net/smc: fix suppressed return code
Date:   Sat, 31 Oct 2020 12:36:32 +0100
Message-Id: <20201031113502.436504992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 96d6fded958d971a3695009e0ed43aca6c598283 ]

The patch that repaired the invalid return code in smcd_new_buf_create()
missed to take care of errno ENOSPC which has a special meaning that no
more DMBEs can be registered on the device. Fix that by keeping this
errno value during the translation of the return code.

Fixes: 6b1bbf94ab36 ("net/smc: fix invalid return code in smcd_new_buf_create()")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1616,8 +1616,11 @@ static struct smc_buf_desc *smcd_new_buf
 		rc = smc_ism_register_dmb(lgr, bufsize, buf_desc);
 		if (rc) {
 			kfree(buf_desc);
-			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) :
-						 ERR_PTR(-EIO);
+			if (rc == -ENOMEM)
+				return ERR_PTR(-EAGAIN);
+			if (rc == -ENOSPC)
+				return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-EIO);
 		}
 		buf_desc->pages = virt_to_page(buf_desc->cpu_addr);
 		/* CDC header stored in buf. So, pretend it was smaller */


