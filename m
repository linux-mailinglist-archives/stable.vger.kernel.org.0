Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00C7191D8
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfEITBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfEISvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2045F20578;
        Thu,  9 May 2019 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427861;
        bh=eZl1+8NsCIrSH23CfGTDEItcXv8IxG4Dp1S/aTL9pgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIj4deTRPPSFu4whJRw/H3vMrgMboGlSI1Qh5cDVtdjwN74r/0362hf/oySyKSy2a
         9oHwhjae+4bh5K0KKN7RA1xxxlOSILcnmk0aj6gwTqW36knwTvFC1Ybcko4PdOH6Np
         OUeot79HoYXzo/HyzTVph9J4unScBSjiHoIi/UTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: [PATCH 5.0 05/95] staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.
Date:   Thu,  9 May 2019 20:41:22 +0200
Message-Id: <20190509181309.679350751@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
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
 drivers/staging/wilc1000/linux_wlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -816,7 +816,7 @@ static void wilc_set_multicast_list(stru
 		return;
 	}
 
-	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_KERNEL);
+	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_ATOMIC);
 	if (!mc_list)
 		return;
 


