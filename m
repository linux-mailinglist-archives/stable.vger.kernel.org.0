Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7742311344D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfLDSXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbfLDSD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:56 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF4792073B;
        Wed,  4 Dec 2019 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482636;
        bh=nqrDeAiqwjw67y0i2EHRlzpeX2mJIKdZBClni9COesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2ASZ2Wj1ijkpV0HIBxt8Q4FS/r47SJFer2BZYiNWsiKKShPMF6tjJDyA8y5+IWBF
         A1R0LLdTX4CwDxGfKbxBdihZvwrJxol6TzflavsIa9DAe8SXxJk7WxYwAJrF1ileIu
         EJNr7GyWfn2NpSH9ERy0fXnahxBAxuYRfNia2WfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/209] rtl818x: fix potential use after free
Date:   Wed,  4 Dec 2019 18:54:20 +0100
Message-Id: <20191204175324.678822977@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit afbb1947db94eacc5a13302eee88a9772fb78935 ]

entry is released via usb_put_urb just after calling usb_submit_urb.
However, entry is used if the submission fails, resulting in a use after
free bug. The patch fixes this.

Signed-off-by: Pan Bian <bianpan2016@163.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 9a1d15b3ce453..518caaaf8a987 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -444,12 +444,13 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_anchor_urb(entry, &priv->anchored);
 		ret = usb_submit_urb(entry, GFP_KERNEL);
-		usb_put_urb(entry);
 		if (ret) {
 			skb_unlink(skb, &priv->rx_queue);
 			usb_unanchor_urb(entry);
+			usb_put_urb(entry);
 			goto err;
 		}
+		usb_put_urb(entry);
 	}
 	return ret;
 
-- 
2.20.1



