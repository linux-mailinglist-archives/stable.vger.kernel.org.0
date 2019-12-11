Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C87E11B7E9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfLKPLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfLKPLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 566C12465A;
        Wed, 11 Dec 2019 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077079;
        bh=1zkA7yqeQ2Mxa55z37h26z1TWshV0LM+nelUIVNp/Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q268eQD+YwKYzym9llRmHJU5Gr54qldRpJYXqRRfYyxe8fHWzjgbUlyg6Al3MVJUB
         SrfG5VswZnJvhD/CujdwLyzXFeY9N7hLzwoaUArhUyKgJN/RJuntYOhvlpnWlNmEDL
         Ao1A0EbFXIoO2kOs3MvdDaJedRZFdDNz2X9CINss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 001/105] rsi: release skb if rsi_prepare_beacon fails
Date:   Wed, 11 Dec 2019 16:04:50 +0100
Message-Id: <20191211150221.978611813@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
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
@@ -1756,6 +1756,7 @@ static int rsi_send_beacon(struct rsi_co
 		skb_pull(skb, (64 - dword_align_bytes));
 	if (rsi_prepare_beacon(common, skb)) {
 		rsi_dbg(ERR_ZONE, "Failed to prepare beacon\n");
+		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 	skb_queue_tail(&common->tx_queue[MGMT_BEACON_Q], skb);


