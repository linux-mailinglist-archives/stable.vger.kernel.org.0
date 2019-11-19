Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6452C1017F9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfKSFhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730032AbfKSFhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EC93214DE;
        Tue, 19 Nov 2019 05:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141821;
        bh=JimTXPtAbX8YoTT19Gr8WHDW98DSZBe8ND3dur/LtAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpcIpKXhTiQOoT+DOFIrYUUggtdcYwUMzQorWT4gCj0zYLfWjCqz0wVUcvkeuauLX
         X2sS0ej+Vp4vUwzUgBKv2NwSFC4mUUwzBdyGYycR0afAekQa+J2jMuZM0el84pzmlm
         HBvthojrCckgngzk5wgf7cjJ9Kyfvb3SWXHVrDtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 292/422] brcmfmac: increase buffer for obtaining firmware capabilities
Date:   Tue, 19 Nov 2019 06:18:09 +0100
Message-Id: <20191119051417.914114118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 59c2a30d36c8ae430d26a902c4c9665ea33ccee5 ]

When obtaining the firmware capability a buffer is provided of 512
bytes. However, if all features in firmware are supported the buffer
needs to be 565 bytes as otherwise truncated information is retrieved
from firmware. Increasing the buffer to 768 bytes on stack.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 8347da632a5b0..4c5a3995dc352 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -178,7 +178,7 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 	ifp->fwil_fwerr = false;
 }
 
-#define MAX_CAPS_BUFFER_SIZE	512
+#define MAX_CAPS_BUFFER_SIZE	768
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
 	char caps[MAX_CAPS_BUFFER_SIZE];
-- 
2.20.1



