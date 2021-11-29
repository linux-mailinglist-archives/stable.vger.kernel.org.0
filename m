Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05772461DCD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378457AbhK2S3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48636 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378448AbhK2S1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C38D5CE140B;
        Mon, 29 Nov 2021 18:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5D2C53FAD;
        Mon, 29 Nov 2021 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210249;
        bh=PM/yQpI+6fYexdm9iC3694oATmfAwBxaiumR98Y7WFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TNrMlBb2yDvHGzN8U4xTpRLTxaAllDLqv4cB2sMg3jsW3pyMqv9Ic5N/e2BP5MGZ
         V0Mqq67W9OdfAEI+A+vW88Bpc2Q2eEca0vKgwNimrNiD1ilyL14mwXE6ju8dxcwF8z
         RhgDinoo6YmPUCAvVOGBSqLs1gjmkUoJ2GtfNH3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        John Keeping <john@metanate.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 04/92] usb: dwc2: hcd_queue: Fix use of floating point literal
Date:   Mon, 29 Nov 2021 19:17:33 +0100
Message-Id: <20211129181707.544406356@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 310780e825f3ffd211b479b8f828885a6faedd63 upstream.

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
 drivers/usb/dwc2/hcd_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd_queue.c
+++ b/drivers/usb/dwc2/hcd_queue.c
@@ -59,7 +59,7 @@
 #define DWC2_UNRESERVE_DELAY (msecs_to_jiffies(5))
 
 /* If we get a NAK, wait this long before retrying */
-#define DWC2_RETRY_WAIT_DELAY 1*1E6L
+#define DWC2_RETRY_WAIT_DELAY (1 * NSEC_PER_MSEC)
 
 /**
  * dwc2_periodic_channel_available() - Checks that a channel is available for a


