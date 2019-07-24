Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC0673B8A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405338AbfGXUBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391853AbfGXUBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:01:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B0F206BA;
        Wed, 24 Jul 2019 20:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998466;
        bh=CqM/3sez9hDpYLVaIcw1Q3PHotGioltshOsUtlzve/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PEk1Wlb73wMRPM5gNw34rOlPGRQe78bz/b4eIA9Mx/4WVVaIthe1dv59qe5R+wPC
         dw0HXEfRAAm0bz36EKs8pGYLjWg27cdWIOyH62LqeEnybHe2NSfytjbZJuXjPxXN+6
         dUaLbqPvBgpVr7pnLNgXgDJU7ZQy9kh6MR9htdL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.1 346/371] gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
Date:   Wed, 24 Jul 2019 21:21:38 +0200
Message-Id: <20190724191749.725185400@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
@@ -257,7 +257,7 @@ static int init_csc(struct ipu_ic *ic,
 	writel(param, base++);
 
 	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
-		(params->sat << 9);
+		(params->sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |


