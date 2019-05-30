Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C52EFD0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfE3D6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbfE3DSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815E0247E6;
        Thu, 30 May 2019 03:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186326;
        bh=WrdlPj9JlrIxJXVWJ9NMP0Y9QTf6mIL8LMV3pc2dYiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT2jHjQhipDnw7JvpxaVWyfjpW1+2n0U4W0Ih5XvzJDK3SobeIZnMK+zH3eFe6ybM
         tBNjP3ePOqH8D4DT7QEys7iBYkdd7Kkb2jTmvvtOVNSZWCd/ax4nQbbLevSCDmuzNX
         MRbeJZrOUapckKWePZ7gLFwBS0D3nlcGhGJ5LhH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 023/193] brcmfmac: assure SSID length from firmware is limited
Date:   Wed, 29 May 2019 20:04:37 -0700
Message-Id: <20190530030452.055518332@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arend van Spriel <arend.vanspriel@broadcom.com>

commit 1b5e2423164b3670e8bc9174e4762d297990deff upstream.

The SSID length as received from firmware should not exceed
IEEE80211_MAX_SSID_LEN as that would result in heap overflow.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3581,6 +3581,8 @@ brcmf_wowl_nd_results(struct brcmf_if *i
 	}
 
 	netinfo = brcmf_get_netinfo_array(pfn_result);
+	if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+		netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
 	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
 	cfg->wowl.nd->n_channels = 1;


