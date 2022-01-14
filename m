Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFC48E5BC
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiANIUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:20:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58478 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbiANITM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CFD561E03;
        Fri, 14 Jan 2022 08:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ECEC36AE9;
        Fri, 14 Jan 2022 08:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148351;
        bh=Uh/Bhv7AqgNt1MvA67kKhA3mQZvo44UFqagmaBRB8yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0JBax1gjwBT0hvswuRKwKSth+ci194SEO1ZgrGd2WlaUc4Hp69a43uno8IFfcJKk
         2O6UfXSOBg4TR0uSwEyoQsb+26PTE57BaxxAaoswlgEGh5fYOVfwCeYCqwtcyaOmWU
         5+uxxDaw+/olgZe7W1Ih/liTJxvWcbwHd7fEVgWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 23/25] staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
Date:   Fri, 14 Jan 2022 09:16:31 +0100
Message-Id: <20220114081543.489065294@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
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
@@ -3779,18 +3779,18 @@ static void hfa384x_usb_throttlefn(struc
 
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


