Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACB2E4325
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405044AbgL1Pdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407410AbgL1NyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D342064B;
        Mon, 28 Dec 2020 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163636;
        bh=/8ee/wHfIlJuwhmBcBGroCS0Ii8mapdb0sG6eD+PMmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9gDJrQRh5jmyak68hUoK59EaSoc7zFho9NfHgligFKMKOwa2cNCbQpYEqMpDHtQS
         32RufMnMNpEu+5Wu6tAGnLejVWaGaP5OC0Tb0+TNs1Uyc3lnzIOraZfwPI1V9mAhlh
         MfP61/02+ht+CcCjV6CshMFmraWt6ahAkzea/G5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rostislav Lisovy <lisovy@gmail.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 355/453] staging: comedi: mf6x4: Fix AI end-of-conversion detection
Date:   Mon, 28 Dec 2020 13:49:51 +0100
Message-Id: <20201228124954.289208627@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 56c90457ebfe9422496aac6ef3d3f0f0ea8b2ec2 upstream.

I have had reports from two different people that attempts to read the
analog input channels of the MF624 board fail with an `ETIMEDOUT` error.

After triggering the conversion, the code calls `comedi_timeout()` with
`mf6x4_ai_eoc()` as the callback function to check if the conversion is
complete.  The callback returns 0 if complete or `-EBUSY` if not yet
complete.  `comedi_timeout()` returns `-ETIMEDOUT` if it has not
completed within a timeout period which is propagated as an error to the
user application.

The existing code considers the conversion to be complete when the EOLC
bit is high.  However, according to the user manuals for the MF624 and
MF634 boards, this test is incorrect because EOLC is an active low
signal that goes high when the conversion is triggered, and goes low
when the conversion is complete.  Fix the problem by inverting the test
of the EOLC bit state.

Fixes: 04b565021a83 ("comedi: Humusoft MF634 and MF624 DAQ cards driver")
Cc: <stable@vger.kernel.org> # v4.4+
Cc: Rostislav Lisovy <lisovy@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20201207145806.4046-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/mf6x4.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/mf6x4.c
+++ b/drivers/staging/comedi/drivers/mf6x4.c
@@ -112,8 +112,9 @@ static int mf6x4_ai_eoc(struct comedi_de
 	struct mf6x4_private *devpriv = dev->private;
 	unsigned int status;
 
+	/* EOLC goes low at end of conversion. */
 	status = ioread32(devpriv->gpioc_reg);
-	if (status & MF6X4_GPIOC_EOLC)
+	if ((status & MF6X4_GPIOC_EOLC) == 0)
 		return 0;
 	return -EBUSY;
 }


