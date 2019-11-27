Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E084510BCC6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfK0VXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732123AbfK0VER (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE26A215E5;
        Wed, 27 Nov 2019 21:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888657;
        bh=0/v6sglde6ETDy/cKQP12kRzT3Ku99PNjbTwDK6rlkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rejjv7/Sys0W52Vc8Uz//7pcRxEUAttuzTZptIODEr8rbJ5eudqnPqGFe7i0TP/2X
         U/rUlU3rmLDW1RrUJ8JWb/ypnpPLku8AbI9VFfzFmXx7m3PatxeGIQ83jJ36vh6w6O
         o07TwSD7Zgugf4Fk/yL8X9hQC6ly/nSaLJXEGTAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/306] wlcore: Fix the return value in case of error in wlcore_vendor_cmd_smart_config_start()
Date:   Wed, 27 Nov 2019 21:31:08 +0100
Message-Id: <20191127203130.994561164@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index dbe78d8491eff..7f34ec077ee57 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -70,7 +70,7 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 out:
 	mutex_unlock(&wl->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.20.1



