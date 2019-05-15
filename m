Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D185C1EFF8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfEOLaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732675AbfEOLaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157A0206BF;
        Wed, 15 May 2019 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919807;
        bh=5lQQSp2MY0e8p5PILottSeNZMveQFwsHmlVtymy3HyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCzR+OUXXxn8boGouc1bCBM0hiR8Zm2SieIfQlJv9dyoOmc3l6Lwz/Kw3Wnc2mkuy
         s4xPHSf+yCszb4tj9+jxh7yzwmn0YT2h5NbPIafOtMXgeVMu3YOAjJeioGB+EhZTe3
         T+MgLT1Jl2vrQ9m0Ze/goOhvYVkdVKsWS5+bRNw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.0 101/137] cw1200: fix missing unlock on error in cw1200_hw_scan()
Date:   Wed, 15 May 2019 12:56:22 +0200
Message-Id: <20190515090700.860655131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 51c8d24101c79ffce3e79137e2cee5dfeb956dd7 upstream.

Add the missing unlock before return from function cw1200_hw_scan()
in the error handling case.

Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/st/cw1200/scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -84,8 +84,11 @@ int cw1200_hw_scan(struct ieee80211_hw *
 
 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
 		req->ie_len);
-	if (!frame.skb)
+	if (!frame.skb) {
+		mutex_unlock(&priv->conf_mutex);
+		up(&priv->scan.lock);
 		return -ENOMEM;
+	}
 
 	if (req->ie_len)
 		skb_put_data(frame.skb, req->ie, req->ie_len);


