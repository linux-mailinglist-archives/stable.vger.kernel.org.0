Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2704F3C447B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhGLGTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233842AbhGLGTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F496610CB;
        Mon, 12 Jul 2021 06:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070583;
        bh=WZZT5w4Bkeo+YwtsfIDG7WBHhky+Y/drB2kLyflO1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5RZEHTxgA3j3tkEl2teLjdZUqlzJTwpEx6TG7F8CcHDVE70HFgYZbG53dzGHRq/Z
         BWAoGCVst8cslgh8EO+whrrnJH1ylNnH/ygCJ8PQ4gUlmk8bs6cDUV8IunqCy5dAyZ
         8yAOWFFzGCqtIi607NPBog3LQNvd0S4tnNznWtO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 052/348] ssb: sdio: Dont overwrite const buffer if block_write fails
Date:   Mon, 12 Jul 2021 08:07:16 +0200
Message-Id: <20210712060708.538662683@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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


