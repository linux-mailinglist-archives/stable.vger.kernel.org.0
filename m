Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21D9D9E55
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438124AbfJPV6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438120AbfJPV6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:10 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F7021D7C;
        Wed, 16 Oct 2019 21:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263089;
        bh=4tGlNSxHASXe77fKr/iwjF7Jn4vL/P/jnQ4dXsy18IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iimiCU9YHyG4l5ylzBEUdVngre0AFrzKNrCz4/2BsXA83BklKosaOel3ciZCUqFXx
         n6wqcZjezrwjrjKSftOQnL1Dg4YF95nG0irtYHu3I6hvoRA2t0YjgUt6EsLrPF2YrX
         OJ0Tmcbz20TP9ArDsiTA/fz8S2rXXCdSeZz3UQuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lo=C3=AFc=20Yhuel?= <loic.yhuel@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 010/112] xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based hosts
Date:   Wed, 16 Oct 2019 14:50:02 -0700
Message-Id: <20191016214846.596424574@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 47f50d61076523e1a0d5a070062c2311320eeca8 upstream.

Early xHCI 1.1 spec did not mention USB 3.1 capable hosts should set
sbrn to 0x31, or that the minor revision is a two digit BCD
containing minor and sub-minor numbers.
This was later clarified in xHCI 1.2.

Some USB 3.1 capable hosts therefore have sbrn set to 0x30, or minor
revision set to 0x1 instead of 0x10.

Detect the USB 3.1 capability correctly for these hosts as well

Fixes: ddd57980a0fd ("xhci: detect USB 3.2 capable host controllers correctly")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Loïc Yhuel <loic.yhuel@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-5-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5078,11 +5078,18 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 		hcd->has_tt = 1;
 	} else {
 		/*
-		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn. Minor revision is a two digit
-		 * BCD containing minor and sub-minor numbers, only show minor.
+		 * Early xHCI 1.1 spec did not mention USB 3.1 capable hosts
+		 * should return 0x31 for sbrn, or that the minor revision
+		 * is a two digit BCD containig minor and sub-minor numbers.
+		 * This was later clarified in xHCI 1.2.
+		 *
+		 * Some USB 3.1 capable hosts therefore have sbrn 0x30, and
+		 * minor revision set to 0x1 instead of 0x10.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+		if (xhci->usb3_rhub.min_rev == 0x1)
+			minor_rev = 1;
+		else
+			minor_rev = xhci->usb3_rhub.min_rev / 0x10;
 
 		switch (minor_rev) {
 		case 2:


