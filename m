Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755371CAB41
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgEHMlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgEHMlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E29272495F;
        Fri,  8 May 2020 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941712;
        bh=JFs8PvW9Eaksh19MTes//uc/Fb1GBekhhNjYYonSPtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGoLiEZs5D7VTrhFVO2ubrmoix/UQaiuqhAL2ZZJ+DNiHHtZ8iFX5RGDhCEQqptTo
         POpLBfzzPOE5NCcZlqJdehfyGqO36gUpJzX1h+UuGYE6zUZJMVlH1BwCuX1qTah9Go
         sWLU3flyp+prMdJfpnCPjuAjvrQjiaCmARWpmBw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Grant Grundler <grundler@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 141/312] mmc: block: return error on failed mmc_blk_get()
Date:   Fri,  8 May 2020 14:32:12 +0200
Message-Id: <20200508123134.397412537@linuxfoundation.org>
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

From: Olof Johansson <olof@lixom.net>

commit f00ab14c252ac459e86194747a1f580ab503c954 upstream.

This used to return -EFAULT, but the function above returns -EINVAL on
the same condition so let's stick to that.

The removal of error return on this path was introduced with b093410c9aef
('mmc: block: copy resp[] data on err for MMC_IOC_MULTI_CMD').

Fixes: b093410c9aef ('mmc: block: copy resp[] data on err for MMC_IOC_MULTI_CMD').
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Grant Grundler <grundler@google.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -668,8 +668,10 @@ static int mmc_blk_ioctl_multi_cmd(struc
 	}
 
 	md = mmc_blk_get(bdev->bd_disk);
-	if (!md)
+	if (!md) {
+		err = -EINVAL;
 		goto cmd_err;
+	}
 
 	card = md->queue.card;
 	if (IS_ERR(card)) {


