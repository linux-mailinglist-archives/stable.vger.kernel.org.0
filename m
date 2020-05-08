Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAEE1CAB65
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgEHMnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgEHMnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D2B24973;
        Fri,  8 May 2020 12:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941795;
        bh=GQS6+EQAyU4PQ2E8sPYaUu3YJ+wCBWJ8k/5K90gMOfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXPJrs2Hn4Gs1YwI5H9ZGo2eN+AAjffUImrZhJtLm2sDW4ylhzo/6BH7LcOnkeunE
         Dd8LtAnmfHeXa7E+Xm8fSN4DP/1uYnbpTAaFLu+BW2YKBkAPzRGxQktznoMEoaKFmc
         In7bw7DZ1t33vV/jZnBlAXeK8Vs078uTFkBBkASY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Auger <eric.auger@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4.4 174/312] VFIO: platform: reset: fix a warning message condition
Date:   Fri,  8 May 2020 14:32:45 +0200
Message-Id: <20200508123136.734835774@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 967628827f404b3063016c138ccc7b06c54350f8 upstream.

This loop ends with count set to -1 and not zero so the warning message
isn't printed when it should be.  I've fixed this by change the postop
to a preop.

Fixes: 0990822c9866 ('VFIO: platform: reset: AMD xgbe reset module')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -110,7 +110,7 @@ int vfio_platform_amdxgbe_reset(struct v
 	usleep_range(10, 15);
 
 	count = 2000;
-	while (count-- && (ioread32(xgmac_regs->ioaddr + DMA_MR) & 1))
+	while (--count && (ioread32(xgmac_regs->ioaddr + DMA_MR) & 1))
 		usleep_range(500, 600);
 
 	if (!count)


