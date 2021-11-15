Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206FC450C28
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhKORfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238185AbhKORdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FD361BFE;
        Mon, 15 Nov 2021 17:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996924;
        bh=YkW54Ki9Rm7PI7jJAHMIiMXvoahIDOnYIWMdyhs4yPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/q4xq7LXWtiwAI+vVPiGE+C6aMv4JTd4zM94k84mSrZhxk2LOlP3Au1ss4j9vPje
         XnPF/0s72+bHoL8CQxu7FSoF41PXXUbR8gHD8GaG/RdF7RJPNHRCjUM18uC1vcppTg
         rPmvePqXfWcfp2tpFo6XwC7a1skA1RHM6izYYNek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 285/355] HID: u2fzero: properly handle timeouts in usb_submit_urb
Date:   Mon, 15 Nov 2021 18:03:29 +0100
Message-Id: <20211115165322.947265420@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrej Shadura <andrew.shadura@collabora.co.uk>

[ Upstream commit 43775e62c4b784f44a159e13ba80e6146a42d502 ]

The wait_for_completion_timeout function returns 0 if timed out or a
positive value if completed. Hence, "less than zero" comparison always
misses timeouts and doesn't kill the URB as it should, leading to
re-sending it while it is active.

Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-u2fzero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index 94f78ffb76d04..67ae2b18e33ac 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -132,7 +132,7 @@ static int u2fzero_recv(struct u2fzero_device *dev,
 
 	ret = (wait_for_completion_timeout(
 		&ctx.done, msecs_to_jiffies(USB_CTRL_SET_TIMEOUT)));
-	if (ret < 0) {
+	if (ret == 0) {
 		usb_kill_urb(dev->urb);
 		hid_err(hdev, "urb submission timed out");
 	} else {
-- 
2.33.0



