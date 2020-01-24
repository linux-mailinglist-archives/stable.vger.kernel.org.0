Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17EC914844E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390343AbgAXLQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgAXLQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:20 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E40B2075D;
        Fri, 24 Jan 2020 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864579;
        bh=RDwvyjBaIWdAl1K1BnuoqzzqZANn1DMMNBmKll9e39Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esVRf2OKGwi9gEgzAFkYaCww6GSLLTEt3JTqVnJ9xtERa8U8VDhxPXrpPNPFN6+oZ
         E0OZ2S9xzUr0uUKTWp5eYDvgxyNy/XbnwFoGk62nJgJPtMhm91LUFb/YHwR9ihZ99s
         gVpVSiqRALi0l1YUYifU/e6VJnaI/tmhWFw3Uf2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 305/639] brcmfmac: fix leak of mypkt on error return path
Date:   Fri, 24 Jan 2020 10:27:55 +0100
Message-Id: <20200124093125.152354588@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a927e8d8ab57e696800e20cf09a72b7dfe3bbebb ]

Currently if the call to brcmf_sdiod_set_backplane_window fails then
error return path leaks mypkt. Fix this by returning by a new
error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
mypkt.  Also remove redundant check on err before calling
brcmf_sdiod_skbuff_write.

Addresses-Coverity: ("Resource Leak")
Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d2f788d886681..710dc59c5d34d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -617,15 +617,13 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
-		return err;
+		goto out;
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	if (!err)
-		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
-					       mypkt);
-
+	err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr, mypkt);
+out:
 	brcmu_pkt_buf_free_skb(mypkt);
 
 	return err;
-- 
2.20.1



