Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6E6411C35
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbhITRHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346142AbhITRFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1BB861503;
        Mon, 20 Sep 2021 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156883;
        bh=26cUiET7IwaZ/nPWBAj8dOUe2ufLufxLuyPvQZFnDeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uw+LIklkF9nq0rXIezp2hJ7zEZ3Ljx6wZbix7rDpRu7vaIekN+PH/mLdk4GuUkR9c
         JBGhJV3wFoahM451dOLmlECx8agmP+X6nXmjWCjaNOM/SPZq0aWnCtwvSaZfXkVYWO
         w2MJ77ZwtzZvqWX3yb7Mxc+niSzVdTrUiEtZHOMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 129/175] staging: ks7010: Fix the initialization of the sleep_status structure
Date:   Mon, 20 Sep 2021 18:42:58 +0200
Message-Id: <20210920163922.297528895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 56315e55119c0ea57e142b6efb7c31208628ad86 ]

'sleep_status' has 3 atomic_t members. Initialize the 3 of them instead of
initializing only 2 of them and setting 0 twice to the same variable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d2e52a33a9beab41879551d0ae2fdfc99970adab.1626856991.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 81c46f4d0935..16d2036018e2 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -1037,9 +1037,9 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 	memset(&priv->wstats, 0, sizeof(priv->wstats));
 
 	/* sleep mode */
+	atomic_set(&priv->sleepstatus.status, 0);
 	atomic_set(&priv->sleepstatus.doze_request, 0);
 	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
 
 	trx_device_init(priv);
 	hostif_init(priv);
-- 
2.30.2



