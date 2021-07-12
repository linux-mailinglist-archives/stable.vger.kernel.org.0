Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598293C47F3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhGLGf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237652AbhGLGen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D7E61166;
        Mon, 12 Jul 2021 06:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071469;
        bh=WZZT5w4Bkeo+YwtsfIDG7WBHhky+Y/drB2kLyflO1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQREsowF4c2vDN6bD7K4bmvdzFZ2a3z16CPm8dhpHaSQxa+O9tRUrKHTxGqPzGjeI
         iBrnk5hcwvkHz8oLtcL0Z7zXRMOmd4+4WvMRjifm+sXsfmGx5hLfiRhmE2TXi+gYMZ
         KMoLuVY5i5/BtkWMM++wRgF9hT1Vci2OBW3Yhk28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 083/593] ssb: sdio: Dont overwrite const buffer if block_write fails
Date:   Mon, 12 Jul 2021 08:04:03 +0200
Message-Id: <20210712060852.282055310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Buesch <m@bues.ch>

commit 47ec636f7a25aa2549e198c48ecb6b1c25d05456 upstream.

It doesn't make sense to clobber the const driver-side buffer, if a
write-to-device attempt failed. All other SSB variants (PCI, PCMCIA and SoC)
also don't corrupt the buffer on any failure in block_write.
Therefore, remove this memset from the SDIO variant.

Signed-off-by: Michael Büsch <m@bues.ch>
Cc: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210515210252.318be2ba@wiggum
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ssb/sdio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -411,7 +411,6 @@ static void ssb_sdio_block_write(struct
 	sdio_claim_host(bus->host_sdio);
 	if (unlikely(ssb_sdio_switch_core(bus, dev))) {
 		error = -EIO;
-		memset((void *)buffer, 0xff, count);
 		goto err_out;
 	}
 	offset |= bus->sdio_sbaddr & 0xffff;


