Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB200F7B79
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfKKSgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbfKKSgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:36:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD6F21655;
        Mon, 11 Nov 2019 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497392;
        bh=unMq+0rqWKGhQxdBrrw7ovMzmr7MwqPJgOifndds6O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkIZoJ9khvBgH7TfD1/YN5+HMgr49qxKcMpuehZ7VnN1OIJbpOH/fywSEIBNoHo7l
         +dWrTbh9XlcAN1cfRIHyxjndAB5PmwE2k40SPcrYk87H/HvpgUYvxiXlimqe8FyX2t
         /n1tYLz11H3H9kUO55Nn9BG1qXon5LoDD9NZ/p+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 037/105] can: gs_usb: gs_can_open(): prevent memory leak
Date:   Mon, 11 Nov 2019 19:28:07 +0100
Message-Id: <20191111181439.403321823@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit fb5be6a7b4863ecc44963bb80ca614584b6c7817 upstream.

In gs_can_open() if usb_submit_urb() fails the allocated urb should be
released.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/gs_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -631,6 +631,7 @@ static int gs_can_open(struct net_device
 					   rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_urb(urb);
 				break;
 			}
 


