Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90AF19145
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfEISzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbfEISzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:55:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CB2204FD;
        Thu,  9 May 2019 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428102;
        bh=lioSarW61e1fg5cWblIDvNnD9WgAyJjR+Tnu0ISsUdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUbtSXLidaizvTbVrfpzeG9cnGJ4DDW8zxixUJ70iLBqfm++b21wUG4L2F61qf/Vq
         8CaWitEUbXm2Vnt3zP0vjP2JrMpKCvGz3QHO2xoy0T66+PHtLLLZZFYNaNpDUlARFs
         UljAA+mciweOuQ7pMqYtILO2P/+RC14p15wFg/v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: [PATCH 5.1 04/30] staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.
Date:   Thu,  9 May 2019 20:42:36 +0200
Message-Id: <20190509181251.512793363@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ae26aa844679cdf660e12c7055f958cb90889eb6 upstream.

Since wilc_set_multicast_list() is called with dev->addr_list_lock
spinlock held, we can't use GFP_KERNEL memory allocation.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: e624c58cf8eb ("staging: wilc1000: refactor code to avoid use of wilc_set_multicast_list global")
Cc: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wilc1000/wilc_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -708,7 +708,7 @@ static void wilc_set_multicast_list(stru
 		return;
 	}
 
-	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_KERNEL);
+	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_ATOMIC);
 	if (!mc_list)
 		return;
 


