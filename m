Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761F5594FBB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiHPEcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiHPEbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071C3160789;
        Mon, 15 Aug 2022 13:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C472060F60;
        Mon, 15 Aug 2022 20:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6133C433C1;
        Mon, 15 Aug 2022 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594962;
        bh=lmgTM1jgIW+D13I6ebHyYB9coqQ/W7q1LTfXY/l42nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02C1r3ObhuO/M4nM7PPo8x+zRoX0qlWd3aD3JdWgtUw4ynlw26SJ4Iz+pReVdM+Wb
         B71J+l3FFP6I4CbhyVU3Ucb+PPu1TB7p3Z0wgdCrn8x0hOyY0S+/dDs4o8+i+cue14
         jF4LF1bxqMzQWLImKtn4r7XVa8EfektISmK3wGbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0612/1157] usbip: vudc: Dont enable IRQs prematurely
Date:   Mon, 15 Aug 2022 19:59:28 +0200
Message-Id: <20220815180504.135785499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 62e4efe3375eb30292dabaec4481dc04550d3644 ]

This code does:

	spin_unlock_irq(&udc->ud.lock);
	spin_unlock_irqrestore(&udc->lock, flags);

which does not make sense.  In theory, the first unlock could enable
IRQs and then the second _irqrestore could disable them again.  There
would be a brief momemt where IRQs were enabled improperly.

In real life, however, this function is always called with IRQs enabled
and the bug does not affect runtime.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Yo4hVWcZNYzKEkIQ@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vudc_sysfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index d1cf6b51bf85..c95e6b2bfd32 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -128,7 +128,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 			goto unlock;
 		}
 
-		spin_lock_irq(&udc->ud.lock);
+		spin_lock(&udc->ud.lock);
 
 		if (udc->ud.status != SDEV_ST_AVAILABLE) {
 			ret = -EINVAL;
@@ -150,7 +150,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 		}
 
 		/* unlock and create threads and get tasks */
-		spin_unlock_irq(&udc->ud.lock);
+		spin_unlock(&udc->ud.lock);
 		spin_unlock_irqrestore(&udc->lock, flags);
 
 		tcp_rx = kthread_create(&v_rx_loop, &udc->ud, "vudc_rx");
@@ -173,14 +173,14 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 
 		/* lock and update udc->ud state */
 		spin_lock_irqsave(&udc->lock, flags);
-		spin_lock_irq(&udc->ud.lock);
+		spin_lock(&udc->ud.lock);
 
 		udc->ud.tcp_socket = socket;
 		udc->ud.tcp_rx = tcp_rx;
 		udc->ud.tcp_tx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
 
-		spin_unlock_irq(&udc->ud.lock);
+		spin_unlock(&udc->ud.lock);
 
 		ktime_get_ts64(&udc->start_time);
 		v_start_timer(udc);
@@ -201,12 +201,12 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 			goto unlock;
 		}
 
-		spin_lock_irq(&udc->ud.lock);
+		spin_lock(&udc->ud.lock);
 		if (udc->ud.status != SDEV_ST_USED) {
 			ret = -EINVAL;
 			goto unlock_ud;
 		}
-		spin_unlock_irq(&udc->ud.lock);
+		spin_unlock(&udc->ud.lock);
 
 		usbip_event_add(&udc->ud, VUDC_EVENT_DOWN);
 	}
@@ -219,7 +219,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 sock_err:
 	sockfd_put(socket);
 unlock_ud:
-	spin_unlock_irq(&udc->ud.lock);
+	spin_unlock(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
 	mutex_unlock(&udc->ud.sysfs_lock);
-- 
2.35.1



