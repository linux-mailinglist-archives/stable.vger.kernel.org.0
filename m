Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B694A1214D1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfLPSPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbfLPSPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF42206EC;
        Mon, 16 Dec 2019 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520118;
        bh=vkloKGbaYFfkabExPf3X+vPpLII7Jcddq16trdxpGuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLmutP3Tsw7KDRx6ThRx2mL4AmsxzILPJNDR9CnMoqP3uB0RbC8rGOWAmsHjnHFBa
         OTePMFDbRkA2pgGrsKNBIWC+XIZ8FOUyq1FCijBs01Qi3XEeuXCIGfRDM4lEvNVhBG
         cjhtoqizVplX4Jr6iKw/qk0s46sbQtdxgy4Ta6cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcgonzalez@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH 5.4 023/177] staging: vchiq: call unregister_chrdev_region() when driver registration fails
Date:   Mon, 16 Dec 2019 18:47:59 +0100
Message-Id: <20191216174819.041877957@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Diop-Gonzalez <marcgonzalez@google.com>

commit d2cdb20507fe2079a146459f9718b45d78cbbe61 upstream.

This undoes the previous call to alloc_chrdev_region() on failure,
and is probably what was meant originally given the label name.

Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 187ac53e590c ("staging: vchiq_arm: rework probe and init functions")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20191203153921.70540-1-marcgonzalez@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -3299,7 +3299,7 @@ static int __init vchiq_driver_init(void
 	return 0;
 
 region_unregister:
-	platform_driver_unregister(&vchiq_driver);
+	unregister_chrdev_region(vchiq_devid, 1);
 
 class_destroy:
 	class_destroy(vchiq_class);


