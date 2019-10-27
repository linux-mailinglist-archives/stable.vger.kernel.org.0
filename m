Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7669E66B6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfJ0VOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbfJ0VOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:32 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF3F205C9;
        Sun, 27 Oct 2019 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210872;
        bh=7hY4nLWxWakh0Bh+snLKU17vH2lbqPEmuhjao7isb9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SacVpT/LEn8c+ggDjjgYvOC1f16nb7gJuAo+Ou3AR3CyFRQY2x2/Ev1JdEBO924ED
         Bp1zrg/W0ZTKeXHGEcze4JtRhgXfzNlP53wbDR3ngj1dYXHODFwf4to4tQ969+dkl3
         csFy9XM6Hy/NHHbJlwUgSXXcWvagJpOBv3E4q1Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.19 47/93] staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS
Date:   Sun, 27 Oct 2019 22:00:59 +0100
Message-Id: <20191027203300.134281452@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
@@ -476,10 +476,8 @@ static int prism2_connect(struct wiphy *
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


