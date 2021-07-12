Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49B73C4B77
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhGLG5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhGLG4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861316102A;
        Mon, 12 Jul 2021 06:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072809;
        bh=FGQZWijx7yrvwMhQHy6HcMcMeU6oKxJ9j9twvjjMCsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0J1FXIkzrAR44VXWuIfX9SNEjBW560kJ43j8VzIMG5rmnxLS6y1aaOW1cNwE59/oI
         z2i8yrSUovs+Yv16idbPiFK3iZo/htqVgRFO9s7aaEoRlK2K8Rlg21Dmib9DMoX/w/
         sgPIsiBEVRVVlcrBr8daiyKeqU1sVX/hu3uZsJPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Janc <szymon.janc@codecoup.pl>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.12 003/700] Bluetooth: Remove spurious error message
Date:   Mon, 12 Jul 2021 08:01:26 +0200
Message-Id: <20210712060925.279456632@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Janc <szymon.janc@codecoup.pl>

commit 1c58e933aba23f68c0d3f192f7cc6eed8fabd694 upstream.

Even with rate limited reporting this is very spammy and since
it is remote device that is providing bogus data there is no
need to report this as error.

Since real_len variable was used only to allow conditional error
message it is now also removed.

[72454.143336] bt_err_ratelimited: 10 callbacks suppressed
[72454.143337] Bluetooth: hci0: advertising data len corrected
[72454.296314] Bluetooth: hci0: advertising data len corrected
[72454.892329] Bluetooth: hci0: advertising data len corrected
[72455.051319] Bluetooth: hci0: advertising data len corrected
[72455.357326] Bluetooth: hci0: advertising data len corrected
[72455.663295] Bluetooth: hci0: advertising data len corrected
[72455.787278] Bluetooth: hci0: advertising data len corrected
[72455.942278] Bluetooth: hci0: advertising data len corrected
[72456.094276] Bluetooth: hci0: advertising data len corrected
[72456.249137] Bluetooth: hci0: advertising data len corrected
[72459.416333] bt_err_ratelimited: 13 callbacks suppressed
[72459.416334] Bluetooth: hci0: advertising data len corrected
[72459.721334] Bluetooth: hci0: advertising data len corrected
[72460.011317] Bluetooth: hci0: advertising data len corrected
[72460.327171] Bluetooth: hci0: advertising data len corrected
[72460.638294] Bluetooth: hci0: advertising data len corrected
[72460.946350] Bluetooth: hci0: advertising data len corrected
[72461.225320] Bluetooth: hci0: advertising data len corrected
[72461.690322] Bluetooth: hci0: advertising data len corrected
[72462.118318] Bluetooth: hci0: advertising data len corrected
[72462.427319] Bluetooth: hci0: advertising data len corrected
[72464.546319] bt_err_ratelimited: 7 callbacks suppressed
[72464.546319] Bluetooth: hci0: advertising data len corrected
[72464.857318] Bluetooth: hci0: advertising data len corrected
[72465.163332] Bluetooth: hci0: advertising data len corrected
[72465.278331] Bluetooth: hci0: advertising data len corrected
[72465.432323] Bluetooth: hci0: advertising data len corrected
[72465.891334] Bluetooth: hci0: advertising data len corrected
[72466.045334] Bluetooth: hci0: advertising data len corrected
[72466.197321] Bluetooth: hci0: advertising data len corrected
[72466.340318] Bluetooth: hci0: advertising data len corrected
[72466.498335] Bluetooth: hci0: advertising data len corrected
[72469.803299] bt_err_ratelimited: 10 callbacks suppressed

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5416,7 +5416,7 @@ static void process_adv_report(struct hc
 	struct hci_conn *conn;
 	bool match;
 	u32 flags;
-	u8 *ptr, real_len;
+	u8 *ptr;
 
 	switch (type) {
 	case LE_ADV_IND:
@@ -5447,14 +5447,10 @@ static void process_adv_report(struct hc
 			break;
 	}
 
-	real_len = ptr - data;
-
-	/* Adjust for actual length */
-	if (len != real_len) {
-		bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
-				       len, real_len);
-		len = real_len;
-	}
+	/* Adjust for actual length. This handles the case when remote
+	 * device is advertising with incorrect data length.
+	 */
+	len = ptr - data;
 
 	/* If the direct address is present, then this report is from
 	 * a LE Direct Advertising Report event. In that case it is


