Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD20E65D5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfJ0VFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbfJ0VFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:05:43 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 978DD2064A;
        Sun, 27 Oct 2019 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210343;
        bh=FXIHqNPnz+9NAMzrKONjsTjF/Zex8ZBGkpnsoFhCgwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OTsbV3XZpay9mYeRlN/o1fPdgL6z5IDpIi9RjiU12DctT+IZlBDScWm4VZ2ZdmBP
         Fs32GbHLNco3MAKAOHe02OQ8bmT2thOUiFPrjFvOFrGVkoCtjwi5rgXgaZpfmhey57
         Mz+uwM/ctbAE1pxYdwm1l8gYrvK019Nqx4Rg+4Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.9 31/49] staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS
Date:   Sun, 27 Oct 2019 22:01:09 +0100
Message-Id: <20191027203145.580889658@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 153c5d8191c26165dbbd2646448ca7207f7796d0 upstream.

Currently the exit return path when sme->key_idx >= NUM_WEPKEYS is via
label 'exit' and this checks if result is non-zero, however result has
not been initialized and contains garbage.  Fix this by replacing the
goto with a return with the error code.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 0ca6d8e74489 ("Staging: wlan-ng: replace switch-case statements with macro")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191014110201.9874-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/cfg80211.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -489,10 +489,8 @@ static int prism2_connect(struct wiphy *
 	/* Set the encryption - we only support wep */
 	if (is_wep) {
 		if (sme->key) {
-			if (sme->key_idx >= NUM_WEPKEYS) {
-				err = -EINVAL;
-				goto exit;
-			}
+			if (sme->key_idx >= NUM_WEPKEYS)
+				return -EINVAL;
 
 			result = prism2_domibset_uint32(wlandev,
 				DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,


