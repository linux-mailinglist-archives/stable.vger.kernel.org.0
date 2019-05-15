Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475D1F2AA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfEOLJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbfEOLJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FFB12084F;
        Wed, 15 May 2019 11:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918548;
        bh=3tTToVMbBpi0ISrfmPxLmKYgdeJv4JBFyjYHrx1Luew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3O0tyNp7wBaSF46HWAh/vzem4OhJ8x+yzeKMBW789zo3K6zpOgcjYT8LtEQ6aeN0
         JhPGqaVb6FKWp5S1UM0DvP92CA+DXy0os5BqgIOZuab7N4ChUNP/UUEj5HauHWaRBt
         bfATrutxmzkC/sR7ZBKpqJ9t72xdUAFo96bvJmm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 175/266] cw1200: fix missing unlock on error in cw1200_hw_scan()
Date:   Wed, 15 May 2019 12:54:42 +0200
Message-Id: <20190515090728.842670128@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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
[iwamatsu: Change the patching file from drivers/net/wireless/st/cw1200/scan.c to
drivers/net/wireless/cw1200/scan.c]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/cw1200/scan.c
+++ b/drivers/net/wireless/cw1200/scan.c
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
 		memcpy(skb_put(frame.skb, req->ie_len), req->ie, req->ie_len);


