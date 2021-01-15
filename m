Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309DE2F799C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbhAOMir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbhAOMiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 990F6235F8;
        Fri, 15 Jan 2021 12:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714286;
        bh=N9q92FrRB1jJ3kdALnSC8g8Ed6wovnglZx7Ms+oJL98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vB37LPBlO4JnOeWk3QuQxpkW+MpuBJ15ql5oIgGvNYuEJa6vALKb1KpGQV/L7o4i4
         XBkTeI+GR4uxv1QeObwNFOOX3VVcz9e6NSAO7d8Jz9xuV8k0wMhnasOGuWlCYjkf9F
         gL89LA/9Rbbf046lvMyFK093qss9v5bFS4xvhR/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 036/103] octeontx2-af: fix memory leak of lmac and lmac->name
Date:   Fri, 15 Jan 2021 13:27:29 +0100
Message-Id: <20210115122007.805095702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ac7996d680d8b4a51bb99bbdcee3dc838b985498 ]

Currently the error return paths don't kfree lmac and lmac->name
leading to some memory leaks.  Fix this by adding two error return
paths that kfree these objects

Addresses-Coverity: ("Resource leak")
Fixes: 1463f382f58d ("octeontx2-af: Add support for CGX link management")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210107123916.189748-1-colin.king@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -862,8 +862,10 @@ static int cgx_lmac_init(struct cgx *cgx
 		if (!lmac)
 			return -ENOMEM;
 		lmac->name = kcalloc(1, sizeof("cgx_fwi_xxx_yyy"), GFP_KERNEL);
-		if (!lmac->name)
-			return -ENOMEM;
+		if (!lmac->name) {
+			err = -ENOMEM;
+			goto err_lmac_free;
+		}
 		sprintf(lmac->name, "cgx_fwi_%d_%d", cgx->cgx_id, i);
 		lmac->lmac_id = i;
 		lmac->cgx = cgx;
@@ -874,7 +876,7 @@ static int cgx_lmac_init(struct cgx *cgx
 						 CGX_LMAC_FWI + i * 9),
 				   cgx_fwi_event_handler, 0, lmac->name, lmac);
 		if (err)
-			return err;
+			goto err_irq;
 
 		/* Enable interrupt */
 		cgx_write(cgx, lmac->lmac_id, CGXX_CMRX_INT_ENA_W1S,
@@ -886,6 +888,12 @@ static int cgx_lmac_init(struct cgx *cgx
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
+
+err_irq:
+	kfree(lmac->name);
+err_lmac_free:
+	kfree(lmac);
+	return err;
 }
 
 static int cgx_lmac_exit(struct cgx *cgx)


