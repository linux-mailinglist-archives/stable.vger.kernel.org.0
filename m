Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34D92F156
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfE3EMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730770AbfE3DQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA74824619;
        Thu, 30 May 2019 03:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186201;
        bh=6z7WVvFQ35yDx4R7rxkvUBwCMe5hVgwFCEIcw1q0/OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw8JDZwhc789RcUogpYG/TcGUJ+CyZ4aF1Wfn5xz8RYiWDcRsTyWecg7zyS38CsKs
         ZmB9YodDWaPDsou8cz7OPGnCVWVXl1zp6c2oybcXqIpi9c3/R7HSazRG4hN8wMP3hy
         5eAPo+WNNVj6q1dNVITvbSaMAHyPZTXWfZEDE+uc=
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
Subject: [PATCH 4.19 028/276] brcmfmac: assure SSID length from firmware is limited
Date:   Wed, 29 May 2019 20:03:06 -0700
Message-Id: <20190530030525.966049895@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
@@ -3466,6 +3466,8 @@ brcmf_wowl_nd_results(struct brcmf_if *i
 	}
 
 	netinfo = brcmf_get_netinfo_array(pfn_result);
+	if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+		netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
 	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
 	cfg->wowl.nd->n_channels = 1;


