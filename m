Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E4200C99
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbgFSOry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388995AbgFSOrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2357D217BA;
        Fri, 19 Jun 2020 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578072;
        bh=teb3FwMcn/LZC2JxJ2kLyr8Dlm6V1HLPADvCts2Aa0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUIgPpI9rVy2ihC2M6qj1H5s/swEIHkSc7T8UkUPp5mha5DyQI/QqQygmpmZIlhkL
         vW3ETcvi9fJ61oiAK/K5CN7HyOu3s+OIukcaRoC2bfZSjDMSdCWdnbB8/xJ3LojaFg
         XRQxBy525yPBYvb4Zam/hOJqgbu3+rjMdBZKUAVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 072/190] mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()
Date:   Fri, 19 Jun 2020 16:31:57 +0200
Message-Id: <20200619141637.192185712@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit f04086c225da11ad16d7f9a2fbca6483ab16dded upstream.

During some scenarios mmc_sdio_init_card() runs a retry path for the UHS-I
specific initialization, which leads to removal of the previously allocated
card. A new card is then re-allocated while retrying.

However, in one of the corresponding error paths we may end up to remove an
already removed card, which likely leads to a NULL pointer exception. So,
let's fix this.

Fixes: 5fc3d80ef496 ("mmc: sdio: don't use rocr to check if the card could support UHS mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200430091640.455-2-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -717,9 +717,8 @@ try_again:
 			/* Retry init sequence, but without R4_18V_PRESENT. */
 			retries = 0;
 			goto try_again;
-		} else {
-			goto remove;
 		}
+		return err;
 	}
 
 	/*


