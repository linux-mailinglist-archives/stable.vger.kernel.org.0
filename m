Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6DE378739
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhEJLOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236161AbhEJLHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89B861939;
        Mon, 10 May 2021 10:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644330;
        bh=FLTjyOyqJvwchvnf8FfR7GtTTxii4g1YA1EfzgPKwug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnWk2rmiVjSXdJxhvn6YW/0P4X0KSSTQnRZ//lM8E90fzKpSDX/KEvWcdfE5VdWlb
         gLovVPavu39iaFPE8Fz6QZBMX23qbZi/B84DqvxOYmp0Z0ldwVTaizgkgC/Gq0l1Jw
         POlyU+davBoQZ52Etuj7yCdEvWb17DyoEzriKUB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.12 007/384] bus: mhi: core: Fix invalid error returning in mhi_queue
Date:   Mon, 10 May 2021 12:16:36 +0200
Message-Id: <20210510102015.115375535@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit 0ecc1c70dcd32c0f081b173a1a5d89952686f271 upstream.

mhi_queue returns an error when the doorbell is not accessible in
the current state. This can happen when the device is in non M0
state, like M3, and needs to be waken-up prior ringing the DB. This
case is managed earlier by triggering an asynchronous M3 exit via
controller resume/suspend callbacks, that in turn will cause M0
transition and DB update.

So, since it's not an error but just delaying of doorbell update, there
is no reason to return an error.

This also fixes a use after free error for skb case, indeed a caller
queuing skb will try to free the skb if the queueing fails, but in
that case queueing has been done.

Fixes: a8f75cb348fd ("mhi: core: Factorize mhi queuing")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1614336782-5809-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/main.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1077,12 +1077,8 @@ static int mhi_queue(struct mhi_device *
 	if (mhi_chan->dir == DMA_TO_DEVICE)
 		atomic_inc(&mhi_cntrl->pending_pkts);
 
-	if (unlikely(!MHI_DB_ACCESS_VALID(mhi_cntrl))) {
-		ret = -EIO;
-		goto exit_unlock;
-	}
-
-	mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl)))
+		mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 
 	if (dir == DMA_FROM_DEVICE)
 		mhi_cntrl->runtime_put(mhi_cntrl);


