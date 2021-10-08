Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D723D4269A3
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbhJHLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242877AbhJHLiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573556159A;
        Fri,  8 Oct 2021 11:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692790;
        bh=/UdlNh7f7lYPnz+426qtUwqXl/taiOVZDfcX5nbAIwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHFABZv8EXXLbb1nVg+wkfJfH0aPsJeCb0Pro2TOSSJ/Cgb4QbFrwCCIxA+GcvW+h
         bGCxRa/HjD2S6jEQdmv73uGt5B3w6tHtYyHTTaLA2NxTGJbr53nvJNxY2bXNPGBzrF
         vPr/BkCrx1SjvWluXZZuGM8S6/cO55+iB7klejt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soeren Moch <smoch@web.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.14 47/48] Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"
Date:   Fri,  8 Oct 2021 13:28:23 +0200
Message-Id: <20211008112721.627447018@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

commit 151a7c12c4fc8340b51e849e4d1fcb7d794777a5 upstream.

This reverts commit b0b524f079a23e440dd22b04e369368dde847533.

Commit b0b524f079a2 ("brcmfmac: use ISO3166 country code and 0 rev
as fallback") changes country setup to directly use ISO3166 country
codes if no more specific code is configured. This was done under
the assumption that brcmfmac firmwares can handle such simple
direct mapping from country codes to firmware ccode values.

Unfortunately this is not true for all chipset/firmware combinations.
E.g. BCM4359/9 devices stop working as access point with this change,
so revert the offending commit to avoid the regression.

Signed-off-by: Soeren Moch <smoch@web.de>
Cc: stable@vger.kernel.org  # 5.14.x
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210926201905.211605-1-smoch@web.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 ++++--------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7455,23 +7455,18 @@ static s32 brcmf_translate_country_code(
 	s32 found_index;
 	int i;
 
+	country_codes = drvr->settings->country_codes;
+	if (!country_codes) {
+		brcmf_dbg(TRACE, "No country codes configured for device\n");
+		return -EINVAL;
+	}
+
 	if ((alpha2[0] == ccreq->country_abbrev[0]) &&
 	    (alpha2[1] == ccreq->country_abbrev[1])) {
 		brcmf_dbg(TRACE, "Country code already set\n");
 		return -EAGAIN;
 	}
 
-	country_codes = drvr->settings->country_codes;
-	if (!country_codes) {
-		brcmf_dbg(TRACE, "No country codes configured for device, using ISO3166 code and 0 rev\n");
-		memset(ccreq, 0, sizeof(*ccreq));
-		ccreq->country_abbrev[0] = alpha2[0];
-		ccreq->country_abbrev[1] = alpha2[1];
-		ccreq->ccode[0] = alpha2[0];
-		ccreq->ccode[1] = alpha2[1];
-		return 0;
-	}
-
 	found_index = -1;
 	for (i = 0; i < country_codes->table_size; i++) {
 		cc = &country_codes->table[i];


