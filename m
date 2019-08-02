Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEE57F160
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbfHBJdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390432AbfHBJdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745822184B;
        Fri,  2 Aug 2019 09:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738413;
        bh=IL+AhAqkgbbrsuckFqFDp5Nf/7BzwpvJH1iwvwBAI3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbPrJTNbfMR15d9Qpv+i8cvjo73N4UiuMeIUouN/ZOdHWLQnOsOmEhjig3snPpY6e
         jZnPq5qYxi2EDqESDqPoxbmd3Orjky+tD5HCud/wcy2qvg4tgYHtRIbGFaq/1pUPp9
         K45IzNtppMPjF4pa0gRCFOK+5goSByjS27l2u3xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4.4 077/158] gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
Date:   Fri,  2 Aug 2019 11:28:18 +0200
Message-Id: <20190802092219.694924228@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

commit 3d1f62c686acdedf5ed9642b763f3808d6a47d1e upstream.

The saturation bit was being set at bit 9 in the second 32-bit word
of the TPMEM CSC. This isn't correct, the saturation bit is bit 42,
which is bit 10 of the second word.

Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/ipu-v3/ipu-ic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -255,7 +255,7 @@ static int init_csc(struct ipu_ic *ic,
 	writel(param, base++);
 
 	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
-		(params->sat << 9);
+		(params->sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |


