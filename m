Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5A83CDB69
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343610AbhGSOmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245425AbhGSOii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F39961264;
        Mon, 19 Jul 2021 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707880;
        bh=NX6T+JQ4U5W0efBTMO+eLxTbyA6wx5uiLGWaPQPm6QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG9ruv2nvlZ/IxXnJNNtHAdunNjGOQOsWScGr2pFVbJ81BlHdkKUkVON3nuLN1QUH
         BB/Aba7IP0c8YR+mR/BhQFC/CPcV2QPJJ5ZXcM/W/AUNySv5jQevs9h8GuTASAvztq
         bxw8B10Wvxii/Mvku37sWngQQ3siSARBihum/gYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/315] crypto: nx - Fix RCU warning in nx842_OF_upd_status
Date:   Mon, 19 Jul 2021 16:49:42 +0200
Message-Id: <20210719144945.936242535@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 2a96726bd0ccde4f12b9b9a9f61f7b1ac5af7e10 ]

The function nx842_OF_upd_status triggers a sparse RCU warning when
it directly dereferences the RCU-protected devdata.  This appears
to be an accident as there was another variable of the same name
that was passed in from the caller.

After it was removed (because the main purpose of using it, to
update the status member was itself removed) the global variable
unintenionally stood in as its replacement.

This patch restores the devdata parameter.

Fixes: 90fd73f912f0 ("crypto: nx - remove pSeries NX 'status' field")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 2e5b4004f0ee..1b8c87770645 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -553,13 +553,15 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  * The status field indicates if the device is enabled when the status
  * is 'okay'.  Otherwise the device driver will be disabled.
  *
- * @prop - struct property point containing the maxsyncop for the update
+ * @devdata: struct nx842_devdata to use for dev_info
+ * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 - Device is available
  *  -ENODEV - Device is not available
  */
-static int nx842_OF_upd_status(struct property *prop)
+static int nx842_OF_upd_status(struct nx842_devdata *devdata,
+			       struct property *prop)
 {
 	const char *status = (const char *)prop->value;
 
@@ -773,7 +775,7 @@ static int nx842_OF_upd(struct property *new_prop)
 		goto out;
 
 	/* Perform property updates */
-	ret = nx842_OF_upd_status(status);
+	ret = nx842_OF_upd_status(new_devdata, status);
 	if (ret)
 		goto error_out;
 
-- 
2.30.2



