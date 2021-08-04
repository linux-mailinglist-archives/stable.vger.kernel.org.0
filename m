Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335A23DFE0B
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhHDJdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhHDJc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 05:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8047360EB9;
        Wed,  4 Aug 2021 09:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628069567;
        bh=lCyffb9PLH1HfSBsp6TDN9RZ6eNQihkh5qfjzkNc6Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ5cF1jNoOVb2h5Tm/m6MVCYxkBWsu64VNhQA39CL/0vukZFhTJLWNseIiT+azT5j
         cDFfmwNugKgDLMIPmB/n2GVcI1LI3oiUcfZRW8ePl1ls7T9Q1gBa7wgX8tM28Ko5+A
         b5f2f6p9z3gkeXk41plHcoHx4Uq88fGN+kAzIv9CAEf36P2xglBR3b08lLMhRQfUfb
         HKPKUdTyY1is1RlGN6B9tccVizWDwup+dshJCv/vg1+XjwJp3ro3c59jlnV1ZH9V8G
         6DLNLjHAkgh6Q/mFeDrIqcnime9Zv2XxEg4mCHqu04G+D92tZIPUYqmMVC5KXhfm3n
         rB7NdLiBjWbnQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mBDFt-0006T8-MT; Wed, 04 Aug 2021 11:32:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: fix GT type detection
Date:   Wed,  4 Aug 2021 11:31:00 +0200
Message-Id: <20210804093100.24811-1-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YQpeE19WIeQO2b//@hovoldconsulting.com>
References: <YQpeE19WIeQO2b//@hovoldconsulting.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At least some PL2303GT have a bcdDevice of 0x305 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Reported-by: Vasily Khoruzhick <anarsoul@gmail.com>
Tested-by: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 17601e32083e..930b3d50a330 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -432,6 +432,7 @@ static int pl2303_detect_type(struct usb_serial *serial)
 	case 0x200:
 		switch (bcdDevice) {
 		case 0x100:
+		case 0x305:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.
-- 
2.31.1

