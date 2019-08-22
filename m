Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4257B99B97
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404551AbfHVRZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404540AbfHVRZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:57 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 639E82341C;
        Thu, 22 Aug 2019 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494756;
        bh=seQynoquBhsfEosIOR5PXp3K4/WUQdH/99onwZUV/c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1cuA3pCNB9Ym7IY05W+W4x3IrODtpSx9HYqi8XoDW8cgMtGyMfLGw57C2X3IJwq+
         o9ESguAgHBZiKnA8Z6jrToEklMhOO/A2Ol9SeK+uuOry2I6PmS8rCyPNDcVIKZ3Qxx
         CrdRhzOtXrr8bBCOpwxbOhxoNI2eHKb+y4oU+x8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 57/85] staging: comedi: dt3000: Fix rounding up of timer divisor
Date:   Thu, 22 Aug 2019 10:19:30 -0700
Message-Id: <20190822171733.691612184@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 8e2a589a3fc36ce858d42e767c3bcd8fc62a512b upstream.

`dt3k_ns_to_timer()` determines the prescaler and divisor to use to
produce a desired timing period.  It is influenced by a rounding mode
and can round the divisor up, down, or to the nearest value.  However,
the code for rounding up currently does the same as rounding down!  Fix
ir by using the `DIV_ROUND_UP()` macro to calculate the divisor when
rounding up.

Also, change the types of the `divider`, `base` and `prescale` variables
from `int` to `unsigned int` to avoid mixing signed and unsigned types
in the calculations.

Also fix a typo in a nearby comment: "improvment" => "improvement".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190812120814.21188-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/dt3000.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -342,9 +342,9 @@ static irqreturn_t dt3k_interrupt(int ir
 static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *nanosec,
 			    unsigned int flags)
 {
-	int divider, base, prescale;
+	unsigned int divider, base, prescale;
 
-	/* This function needs improvment */
+	/* This function needs improvement */
 	/* Don't know if divider==0 works. */
 
 	for (prescale = 0; prescale < 16; prescale++) {
@@ -358,7 +358,7 @@ static int dt3k_ns_to_timer(unsigned int
 			divider = (*nanosec) / base;
 			break;
 		case CMDF_ROUND_UP:
-			divider = (*nanosec) / base;
+			divider = DIV_ROUND_UP(*nanosec, base);
 			break;
 		}
 		if (divider < 65536) {


