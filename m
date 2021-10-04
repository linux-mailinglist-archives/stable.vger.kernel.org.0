Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F64421070
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhJDNoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhJDNmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C246325B;
        Mon,  4 Oct 2021 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353566;
        bh=ZMUJaosnSfpumiE1XUBa4H9et9EkphiGvIelb+9USeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsIxZHBDQ3VfM6KOgoDESMtxPAN0jtozTn6SjkkmYO02D+dnTXSuRYDIUf/inb1mH
         ipfq2ZVt3XllTgGMb1KVZnFdB8w2G+dPGhA2dt4k+Zx/TDBsx1HiVuPMYw/5Kk2Uah
         bCR6nJtay9N3YskSSiV1AbFzxBLkYGSeIRhc80Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 172/172] drivers: net: mhi: fix error path in mhi_net_newlink
Date:   Mon,  4 Oct 2021 14:53:42 +0200
Message-Id: <20211004125050.532085067@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 4526fe74c3c5095cc55931a3a6fb4932f9e06002 upstream.

Fix double free_netdev when mhi_prepare_for_transfer fails.

Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mhi/net.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -337,7 +337,7 @@ static int mhi_net_newlink(void *ctxt, s
 	/* Start MHI channels */
 	err = mhi_prepare_for_transfer(mhi_dev);
 	if (err)
-		goto out_err;
+		return err;
 
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
@@ -347,7 +347,7 @@ static int mhi_net_newlink(void *ctxt, s
 	else
 		err = register_netdev(ndev);
 	if (err)
-		goto out_err;
+		return err;
 
 	if (mhi_netdev->proto) {
 		err = mhi_netdev->proto->init(mhi_netdev);
@@ -359,8 +359,6 @@ static int mhi_net_newlink(void *ctxt, s
 
 out_err_proto:
 	unregister_netdevice(ndev);
-out_err:
-	free_netdev(ndev);
 	return err;
 }
 


