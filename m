Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D0498ABE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiAXTGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiAXTEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:04:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F21EB8119D;
        Mon, 24 Jan 2022 19:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795F7C340E5;
        Mon, 24 Jan 2022 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051059;
        bh=ztpCR6A4cAUTgphjykzOYVXIwmG7Xly0eAPKd2e9hcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+bJ2xUlUtARD9fRlUQoUOtHsYNxd1ceoTNvf2vXOlNAnkyGnccH6QPHyjyMA8Bsw
         tBrHZ2VdePCbIQv3S2bfOW6M4pSxPqwkpcg9x9k6jPxd71+2keZxKAyHrU0fSv9fE8
         fGgWuHd322e5FRm/aqsy8kBqGmXuF9TvyTrQt0sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.14 009/186] staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
Date:   Mon, 24 Jan 2022 19:41:24 +0100
Message-Id: <20220124183937.412518722@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 502408a61f4b7eb4713f44bd77f4a48e6cb1b59a upstream.

A new warning in clang points out a place in this file where a bitwise
OR is being used with boolean expressions:

In file included from drivers/staging/wlan-ng/prism2usb.c:2:
drivers/staging/wlan-ng/hfa384x_usb.c:3787:7: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
            ((test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
            ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/staging/wlan-ng/hfa384x_usb.c:3787:7: note: cast one or both operands to int to silence this warning
1 warning generated.

The comment explains that short circuiting here is undesirable, as the
calls to test_and_{clear,set}_bit() need to happen for both sides of the
expression.

Clang's suggestion would work to silence the warning but the readability
of the expression would suffer even more. To clean up the warning and
make the block more readable, use a variable for each side of the
bitwise expression.

Link: https://github.com/ClangBuiltLinux/linux/issues/1478
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211014215703.3705371-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3904,18 +3904,18 @@ static void hfa384x_usb_throttlefn(unsig
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
 
-	/*
-	 * We need to check BOTH the RX and the TX throttle controls,
-	 * so we use the bitwise OR instead of the logical OR.
-	 */
 	pr_debug("flags=0x%lx\n", hw->usb_flags);
-	if (!hw->wlandev->hwremoved &&
-	    ((test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags)) |
-	     (test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags))
-	    )) {
-		schedule_work(&hw->usb_work);
+	if (!hw->wlandev->hwremoved) {
+		bool rx_throttle = test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags);
+		bool tx_throttle = test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags);
+		/*
+		 * We need to check BOTH the RX and the TX throttle controls,
+		 * so we use the bitwise OR instead of the logical OR.
+		 */
+		if (rx_throttle | tx_throttle)
+			schedule_work(&hw->usb_work);
 	}
 
 	spin_unlock_irqrestore(&hw->ctlxq.lock, flags);


