Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772D3D9FA1
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437929AbfJPV4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437915AbfJPV4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A967321D7E;
        Wed, 16 Oct 2019 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263008;
        bh=ZGQlvPKmwwuGpmVF+kmEnuCd8wrKkvBiZBKBsh4ybRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+0c2pc2usByO7/VUwObzNe5tSU9axGQdkpLuV4KpUeiRdkOtmS3VUFAioYv6ROKa
         SsJ+sgb2LsHX9S9Lq9Coa1ttI/UfzgD7I8ZYVPRVbAziPfZe1FuFecD7IuR1Fv3Pl0
         6CfXjt6DjF5Eb87Eig4Er+Su2BbuosE1GdVYKtAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lo=C3=AFc=20Yhuel?= <loic.yhuel@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 11/81] xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based hosts
Date:   Wed, 16 Oct 2019 14:50:22 -0700
Message-Id: <20191016214815.472904288@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
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
@@ -5036,11 +5036,18 @@ int xhci_gen_setup(struct usb_hcd *hcd,
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


