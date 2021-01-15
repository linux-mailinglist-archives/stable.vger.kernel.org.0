Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4512F79B7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbhAOMkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388389AbhAOMj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 188D22333E;
        Fri, 15 Jan 2021 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714357;
        bh=Lgw0Ce23wn/kr4A8Sthgtv3KdFHeTQmZsWY0kU1VoDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V8ugR1dX37n3c2J6HpQBPhOss3rnM0I+4wpYv6IxGaq7PDpVRS6N8VIQ1ipLxXpB
         7YwTOfgxmhIpo7Ie9BCRUQerhJL1Uo4tdYPU8ttjjH+r1w4TEX0QvWjrtyLNrm+FrE
         tPhYdquLu4+v5fcm7EpO1hmixq7ZVsd+kpMr99dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 069/103] dmaengine: milbeaut-xdmac: Fix a resource leak in the error handling path of the probe function
Date:   Fri, 15 Jan 2021 13:28:02 +0100
Message-Id: <20210115122009.380222848@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit d645148cc82ca7fbacaa601414a552184e9c6dd3 upstream.

'disable_xdmac()' should be called in the error handling path of the
probe function to undo a previous 'enable_xdmac()' call, as already
done in the remove function.

Fixes: a6e9be055d47 ("dmaengine: milbeaut-xdmac: Add XDMAC driver for Milbeaut platforms")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201219132800.183254-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/milbeaut-xdmac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/milbeaut-xdmac.c
+++ b/drivers/dma/milbeaut-xdmac.c
@@ -351,7 +351,7 @@ static int milbeaut_xdmac_probe(struct p
 
 	ret = dma_async_device_register(ddev);
 	if (ret)
-		return ret;
+		goto disable_xdmac;
 
 	ret = of_dma_controller_register(dev->of_node,
 					 of_dma_simple_xlate, mdev);
@@ -364,6 +364,8 @@ static int milbeaut_xdmac_probe(struct p
 
 unregister_dmac:
 	dma_async_device_unregister(ddev);
+disable_xdmac:
+	disable_xdmac(mdev);
 	return ret;
 }
 


