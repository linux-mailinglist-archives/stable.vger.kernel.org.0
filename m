Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02727D6445
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731892AbfJNNmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731783AbfJNNmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 09:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3AB20854;
        Mon, 14 Oct 2019 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571060565;
        bh=qUMWFVbNMS6wkou/F/t/cDWnsI9Z+S7RT8ZD7EyqxwA=;
        h=Subject:To:From:Date:From;
        b=UGTXedWzD3BLseo/h8hPEzk1NSPAN4QNZ41zEnbu/e+OdLddTFY+TjwlUBlmi8cyw
         bKpsjuHgEfV2ZQMuDnG24UAZNgfgU7xrHR3PSU6m5ujNw62bCIjV6AO5OOv9D2UfmK
         Hwva/PhLkzzCf4+/DXqlxnceac96JXhsq16H8LSs=
Subject: patch "staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS" added to staging-linus
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 15:42:42 +0200
Message-ID: <1571060562245182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 153c5d8191c26165dbbd2646448ca7207f7796d0 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Mon, 14 Oct 2019 12:02:01 +0100
Subject: staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS

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
 drivers/staging/wlan-ng/cfg80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index eee1998c4b18..fac38c842ac5 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -469,10 +469,8 @@ static int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
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
 				DIDMIB_DOT11SMT_PRIVACYTABLE_WEPDEFAULTKEYID,
-- 
2.23.0


