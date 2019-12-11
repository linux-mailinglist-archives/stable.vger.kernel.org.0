Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26ED11B5BC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfLKPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731606AbfLKPP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3743A20663;
        Wed, 11 Dec 2019 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077357;
        bh=ESjPuuCYnyZqtvAfx6qbPGuFdHtHUOfTeHNBFoCrBgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Px5awntb+AfQZH4MdfHN6hEdtAUgW6LKhpsxl4Z8HlKUI5i5tP2tirAzTZAY2dUGm
         pxRK5TTt4VKM8C/qHwpOjA1pnugGfXZ/1LfyNwNO4P3sY71lwVT42oCC4xgeotwgXX
         FnG0x8upxlwiMsQFGG/ZoCJ5IBS6M1IHV+Akq/AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 001/243] rsi: release skb if rsi_prepare_beacon fails
Date:   Wed, 11 Dec 2019 16:02:43 +0100
Message-Id: <20191211150339.267117446@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit d563131ef23cbc756026f839a82598c8445bc45f upstream.

In rsi_send_beacon, if rsi_prepare_beacon fails the allocated skb should
be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1583,6 +1583,7 @@ static int rsi_send_beacon(struct rsi_co
 		skb_pull(skb, (64 - dword_align_bytes));
 	if (rsi_prepare_beacon(common, skb)) {
 		rsi_dbg(ERR_ZONE, "Failed to prepare beacon\n");
+		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 	skb_queue_tail(&common->tx_queue[MGMT_BEACON_Q], skb);


