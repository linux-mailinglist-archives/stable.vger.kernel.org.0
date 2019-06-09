Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AF03A91E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfFIRGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388588AbfFIRGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5029D204EC;
        Sun,  9 Jun 2019 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099980;
        bh=dbiKq53ZEdnYqOxVXfRDsv9rp54xWHJH215bvi/pXPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N98+dLwzRCBDXIJWKoacstGDJTFIl/aHx5vXYvL4OE3+50BEVh1eXdXrgqXDyK1g
         YhdGaxWgL7z66UsZK3KM1DEIiKP5sMyWwT2YezbcBgqdM/NqWneCZ8GNdwYm7hm8x0
         M1ctXJz0ImVnKev/eW/ki2zCWOjvwMboXZDrhl7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 228/241] media: uvcvideo: Fix uvc_alloc_entity() allocation alignment
Date:   Sun,  9 Jun 2019 18:42:50 +0200
Message-Id: <20190609164155.298801610@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 89dd34caf73e28018c58cd193751e41b1f8bdc56 upstream.

The use of ALIGN() in uvc_alloc_entity() is incorrect, since the size of
(entity->pads) is not a power of two. As a stop-gap, until a better
solution is adapted, use roundup() instead.

Found by a static assertion. Compile-tested only.

Fixes: 4ffc2d89f38a ("uvcvideo: Register subdevices for each entity")

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/uvc/uvc_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -868,7 +868,7 @@ static struct uvc_entity *uvc_alloc_enti
 	unsigned int size;
 	unsigned int i;
 
-	extra_size = ALIGN(extra_size, sizeof(*entity->pads));
+	extra_size = roundup(extra_size, sizeof(*entity->pads));
 	num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
 	size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
 	     + num_inputs;


