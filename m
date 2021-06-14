Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1593A641F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhFNLVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235661AbhFNLSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D9861356;
        Mon, 14 Jun 2021 10:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667854;
        bh=RG+0vC/LwpzoJJ5+UUroxxJrHorNwIQs3bem0xBL81M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN+HdrZYmRgH/AAkdvRb39ozWVsNN1KMQFOerRiLkDvhmXAVHnCz+HOnpL+R/c/NL
         iljXMRyuKmtkBoOuuVtL+r+IXCBH0CqG3wnpeNdzVUHx6jr++fdZ6Qru8vZEtAwDWZ
         rEjmlnaSBEHYPJTFonnYtIs5aOQv5N4gv2t0wz38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.12 067/173] usb: misc: brcmstb-usb-pinmap: check return value after calling platform_get_resource()
Date:   Mon, 14 Jun 2021 12:26:39 +0200
Message-Id: <20210614102700.391201438@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit fbf649cd6d64d40c03c5397ecd6b1ae922ba7afc upstream.

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Fixes: 517c4c44b323 ("usb: Add driver to allow any GPIO to be used for 7211 USB signals")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210605080914.2057758-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/brcmstb-usb-pinmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/misc/brcmstb-usb-pinmap.c
+++ b/drivers/usb/misc/brcmstb-usb-pinmap.c
@@ -263,6 +263,8 @@ static int __init brcmstb_usb_pinmap_pro
 		return -EINVAL;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
 
 	pdata = devm_kzalloc(&pdev->dev,
 			     sizeof(*pdata) +


