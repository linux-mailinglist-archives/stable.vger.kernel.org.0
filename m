Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88275E6653
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfJ0VKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfJ0VKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E5220873;
        Sun, 27 Oct 2019 21:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210645;
        bh=9wfYJ86MlnnLvv4todEkNfb2aWKG/3Ov7BSF6kFRxJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRsKz0j4xHnM3wx5xUV6gW1be/CVkz2mFE+O4KJK5Sq789qqQNMdpQOfSBu6iGCIs
         b4yk+R/jxpT3cHqyCasPzTCecbsWU/KMXsv50Y3Jk0FT7P23XZZb1o+Oi/bZBcFf9c
         EnnJqkf/JRlXGvTbQvjIW9VN4LPSE7vY4sZ5K8+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.14 086/119] staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS
Date:   Sun, 27 Oct 2019 22:01:03 +0100
Message-Id: <20191027203347.229722142@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
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
@@ -490,10 +490,8 @@ static int prism2_connect(struct wiphy *
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


