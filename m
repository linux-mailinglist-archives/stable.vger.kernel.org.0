Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78933CD8F5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242861AbhGSO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244014AbhGSOYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D696113B;
        Mon, 19 Jul 2021 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707091;
        bh=WZZT5w4Bkeo+YwtsfIDG7WBHhky+Y/drB2kLyflO1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH9mQLL+wOESRbw4Yb7m56JkAMgyIsmiCVpjwwk7j4BMElJONOE9+HkajarJpBQBB
         FEPcH0xVrKN/cTb7OIVVLbE8LtCGGPazagY6mR72+6K/mCaJvN3JKN1fGQEQYhsDZ7
         6c62UhqubSR/fX2HYkAxH9xQkGGqtdyvS/d0NjLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 026/245] ssb: sdio: Dont overwrite const buffer if block_write fails
Date:   Mon, 19 Jul 2021 16:49:28 +0200
Message-Id: <20210719144941.247803849@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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


