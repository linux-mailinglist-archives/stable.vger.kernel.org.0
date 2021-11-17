Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3159345481A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhKQOHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhKQOH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4EE6187F;
        Wed, 17 Nov 2021 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157871;
        bh=bfErSRBb6v8WcRSmkm9UJIp/G0FcAgfhM2Gxg+Yifpo=;
        h=Subject:To:From:Date:From;
        b=F5HCPuOqS9hL3YcynQrNnFanVhc+p3SAf/U/JP1VgOZAnlN6tSfmYm2vzPtkTHreL
         7rZvmRlAXW4kyAdE6/i8ujEIHgiYpY5hrCeAaJdIctpmksA80vK4TIdZ3PPlnZgODs
         53vj1/g5dkVarSJ2z03mh39xPHOE/Q04QGobj6lM=
Subject: patch "usb: dwc2: hcd_queue: Fix use of floating point literal" added to usb-linus
To:     nathan@kernel.org, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, john@metanate.com,
        ndesaulniers@google.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:04:28 +0100
Message-ID: <16371578681867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: hcd_queue: Fix use of floating point literal

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 310780e825f3ffd211b479b8f828885a6faedd63 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 5 Nov 2021 07:58:03 -0700
Subject: usb: dwc2: hcd_queue: Fix use of floating point literal

A new commit in LLVM causes an error on the use of 'long double' when
'-mno-x87' is used, which the kernel does through an alias,
'-mno-80387' (see the LLVM commit below for more details around why it
does this).

 drivers/usb/dwc2/hcd_queue.c:1744:25: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
                         delay = ktime_set(0, DWC2_RETRY_WAIT_DELAY);
                                             ^
 drivers/usb/dwc2/hcd_queue.c:62:34: note: expanded from macro 'DWC2_RETRY_WAIT_DELAY'
 #define DWC2_RETRY_WAIT_DELAY (1 * 1E6L)
                                 ^
 1 error generated.

This happens due to the use of a 'long double' literal. The 'E6' part of
'1E6L' causes the literal to be a 'double' then the 'L' suffix promotes
it to 'long double'.

There is no visible reason for a floating point value in this driver, as
the value is only used as a parameter to a function that expects an
integer type. Use NSEC_PER_MSEC, which is the same integer value as
'1E6L', to avoid changing functionality but fix the error.

Link: https://github.com/ClangBuiltLinux/linux/issues/1497
Link: https://github.com/llvm/llvm-project/commit/a8083d42b1c346e21623a1d36d1f0cadd7801d83
Fixes: 6ed30a7d8ec2 ("usb: dwc2: host: use hrtimer for NAK retries")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: John Keeping <john@metanate.com>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211105145802.2520658-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd_queue.c b/drivers/usb/dwc2/hcd_queue.c
index 89a788326c56..24beff610cf2 100644
--- a/drivers/usb/dwc2/hcd_queue.c
+++ b/drivers/usb/dwc2/hcd_queue.c
@@ -59,7 +59,7 @@
 #define DWC2_UNRESERVE_DELAY (msecs_to_jiffies(5))
 
 /* If we get a NAK, wait this long before retrying */
-#define DWC2_RETRY_WAIT_DELAY (1 * 1E6L)
+#define DWC2_RETRY_WAIT_DELAY (1 * NSEC_PER_MSEC)
 
 /**
  * dwc2_periodic_channel_available() - Checks that a channel is available for a
-- 
2.34.0


