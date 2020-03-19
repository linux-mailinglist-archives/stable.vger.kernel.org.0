Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E09B18B5CC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCSNVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729973AbgCSNVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13033206D7;
        Thu, 19 Mar 2020 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624096;
        bh=f4ILGXd3AahYpDxTsi3kCJTRTaAOwBuxdxpiOz51kJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3mvu30lIJ7+czHXR017f16mKID2J6+SVYlowm97udqcN9CRDZREHQcNGt4Y7VC91
         pDJ8Bv6qjopXbmhKCceD+d2h1bEUSSVLWu1wGXhKU1gVwbEeHgs+tjENhODq3d1Nkw
         +6P+n/kNUHHQdmGD1KT9vpYDm1dWKBHBfG/1Cwx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 4.19 36/48] driver core: Remove the link if there is no driver with AUTO flag
Date:   Thu, 19 Mar 2020 14:04:18 +0100
Message-Id: <20200319123914.271629274@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

commit 0fe6f7874d467456da6f6a221dd92499a3ab1780 upstream.

DL_FLAG_AUTOREMOVE_CONSUMER/SUPPLIER means "Remove the link
automatically on consumer/supplier driver unbind", that means we should
remove whole the device_link when there is no this driver no matter what
the ref_count of the link is.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -546,7 +546,7 @@ static void __device_links_no_driver(str
 			continue;
 
 		if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER)
-			kref_put(&link->kref, __device_link_del);
+			__device_link_del(&link->kref);
 		else if (link->status != DL_STATE_SUPPLIER_UNBIND)
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 	}
@@ -591,7 +591,7 @@ void device_links_driver_cleanup(struct
 		 */
 		if (link->status == DL_STATE_SUPPLIER_UNBIND &&
 		    link->flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
-			kref_put(&link->kref, __device_link_del);
+			__device_link_del(&link->kref);
 
 		WRITE_ONCE(link->status, DL_STATE_DORMANT);
 	}


