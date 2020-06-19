Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F29201365
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392240AbgFSPNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390715AbgFSPNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1E520776;
        Fri, 19 Jun 2020 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579622;
        bh=QpqFatomJNIZinxVMriLwhh76eQ5JXxDrrQ4EMDUW1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpOjk/rbxQW+5GgGCW25+AK5jgAvtGzfnIGoU2qi4sjCke5ZKZoh4eaaw39JTYR/w
         Txz5Cyic32HmcAnTwfrJOvcO1XaP51ZqOyPsQ+l0RtBEMJb2RlvB9VoW7FhdbTBPVt
         O0jpoZwWlkkx5nEx5qE1Azedn7R1OLzP/C0QlOEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 205/261] b43_legacy: Fix connection problem with WPA3
Date:   Fri, 19 Jun 2020 16:33:36 +0200
Message-Id: <20200619141659.721526380@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 6a29d134c04a8acebb7a95251acea7ad7abba106 upstream.

Since the driver was first introduced into the kernel, it has only
handled the ciphers associated with WEP, WPA, and WPA2. It fails with
WPA3 even though mac80211 can handle those additional ciphers in software,
b43legacy did not report that it could handle them. By setting MFP_CAPABLE using
ieee80211_set_hw(), the problem is fixed.

With this change, b43legacy will handle the ciphers it knows in hardware,
and let mac80211 handle the others in software. It is not necessary to
use the module parameter NOHWCRYPT to turn hardware encryption off.
Although this change essentially eliminates that module parameter,
I am choosing to keep it for cases where the hardware is broken,
and software encryption is required for all ciphers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200526155909.5807-3-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/b43legacy/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3801,6 +3801,7 @@ static int b43legacy_wireless_init(struc
 	/* fill hw info */
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, MFP_CAPABLE); /* Allow WPA3 in software */
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |


