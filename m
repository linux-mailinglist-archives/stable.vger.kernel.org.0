Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E8310BE16
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfK0Uvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfK0Uvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14FB21774;
        Wed, 27 Nov 2019 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887895;
        bh=w+q6BL0CoPHRaEY79kEP5MAZuqvdmh1WzmsnEEQrdhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWXyklMSEuuUbGc0+qn1jXG2yvXwKOdoBenl1Bu4D8tzrRcUhYD/7qbPR+knT9ReT
         mxOBnH0USK5nZihOz2EIwYcxhfdkR/PdQ5+WSaXfrgbip6qB2PYRwOUMas5krFfRGE
         Kv4KJJck1Pi387yLOlKSUD6yJbikSjXkk3/BKM7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 134/211] wlcore: Fix the return value in case of error in wlcore_vendor_cmd_smart_config_start()
Date:   Wed, 27 Nov 2019 21:31:07 +0100
Message-Id: <20191127203106.689178028@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3419348a97bcc256238101129d69b600ceb5cc70 ]

We return 0 unconditionally at the end of
'wlcore_vendor_cmd_smart_config_start()'.
However, 'ret' is set to some error codes in several error handling paths
and we already return some error codes at the beginning of the function.

Return 'ret' instead to propagate the error code.

Fixes: 80ff8063e87c ("wlcore: handle smart config vendor commands")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
index 5c0bcb1fe1a1f..e75c3cee0252f 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -66,7 +66,7 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 out:
 	mutex_unlock(&wl->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.20.1



