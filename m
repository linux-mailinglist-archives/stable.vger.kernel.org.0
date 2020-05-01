Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777951C151A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbgEANpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbgEANpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A972051A;
        Fri,  1 May 2020 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340718;
        bh=ZGFQnPj+OU8LVyvSqdIHmCAuOxQ6QFw+O6SrVP/NNeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQJAOz6TVSeVFhGa9mv8G0G/dnEjpstk1KrJklbGNgWKsCd5AXzHmFhi7jA4ASHqX
         ncL3RNxQeBhS7ODKsXJhEsBH7vMN0RhO7TaDPEnJOcerReMpUjPgZGLU1YHVV9xiqA
         tgFLEkg438PUwH2xsFfQZkaCx2qXabAobAKJKeU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 100/106] Crypto: chelsio - Fixes a hang issue during driver registration
Date:   Fri,  1 May 2020 15:24:13 +0200
Message-Id: <20200501131555.236481009@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

commit ad59ddd02de26271b89564962e74d689f1a30b49 upstream.

This issue occurs only when multiadapters are present. Hang
happens because assign_chcr_device returns u_ctx pointer of
adapter which is not yet initialized as for this adapter cxgb_up
is not been called yet.

The last_dev pointer is used to determine u_ctx pointer and it
is initialized two times in chcr_uld_add in chcr_dev_add respectively.

The fix here is don't initialize the last_dev pointer during
chcr_uld_add. Only assign to value to it when the adapter's
initialization is completed i.e in chcr_dev_add.

Fixes: fef4912b66d62 ("crypto: chelsio - Handle PCI shutdown event").

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/chelsio/chcr_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -125,8 +125,6 @@ static void chcr_dev_init(struct uld_ctx
 	atomic_set(&dev->inflight, 0);
 	mutex_lock(&drv_data.drv_mutex);
 	list_add_tail(&u_ctx->entry, &drv_data.inact_dev);
-	if (!drv_data.last_dev)
-		drv_data.last_dev = u_ctx;
 	mutex_unlock(&drv_data.drv_mutex);
 }
 


