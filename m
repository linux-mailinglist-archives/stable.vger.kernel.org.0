Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AA37C32C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhELPRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhELPQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4CC61981;
        Wed, 12 May 2021 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831927;
        bh=9m/TwkgxOlj5FNTpbQ7MuMQxwO46mEjF4yQitXn0H+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkkeVkhYr5mKMcjPv3rtITsH5qxZYegRTCNRmiwoIvGV2dm/PYpUf6eocgzBcF+yU
         7EE4TVt6nBPsit+rs8KkoDWWLNnZl0f9dXc1P8y3GvWRXg+fS69oDH2hcHDAwQ3Q5U
         Xs+qtHVxvVTwwyRGz/9pk/mX5AlK2AerCVaV104U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annaliese McDermond <nh6z@nh6z.net>
Subject: [PATCH 5.10 037/530] sc16is7xx: Defer probe if device read fails
Date:   Wed, 12 May 2021 16:42:27 +0200
Message-Id: <20210512144820.964273287@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Annaliese McDermond <nh6z@nh6z.net>

commit 158e800e0fde91014812f5cdfb92ce812e3a33b4 upstream.

A test was added to the probe function to ensure the device was
actually connected and working before successfully completing a
probe.  If the device was actually there, but the I2C bus was not
ready yet for whatever reason, the probe fails permanently.

Change the probe so that we defer the probe on a regmap read
failure so that we try the probe again when the dependent drivers
are potentially loaded.  This should not affect the case where the
device truly isn't present because the probe will never successfully
complete.

Fixes: 2aa916e67db3 ("sc16is7xx: Read the LSR register for basic device presence check")
Cc: stable@vger.kernel.org
Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
Link: https://lore.kernel.org/r/010101787f9c3fd8-c1815c00-2d6b-4c85-a96a-a13e68597fda-000000@us-west-2.amazonses.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1196,7 +1196,7 @@ static int sc16is7xx_probe(struct device
 	ret = regmap_read(regmap,
 			  SC16IS7XX_LSR_REG << SC16IS7XX_REG_SHIFT, &val);
 	if (ret < 0)
-		return ret;
+		return -EPROBE_DEFER;
 
 	/* Alloc port structure */
 	s = devm_kzalloc(dev, struct_size(s, p, devtype->nr_uart), GFP_KERNEL);


