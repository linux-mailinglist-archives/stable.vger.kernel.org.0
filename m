Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1F1215DE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfLPSR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:17:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfLPSR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0D52166E;
        Mon, 16 Dec 2019 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520278;
        bh=T0ZeePh69wfZFJoEVb5zMxvl/KiHPmT9h9JmdM695A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5VI4YOJJMsLnuwNPZys4FOpLdb7bTy8yY1blTa0L6BEmZLIQ2xOWOnhMsH29imh+
         /R75Rx2c5iy46u+TOwOxCf1QS7zurS48Mr/DJcfZoAbOye2/1C59hbENTtMPhi3Fr5
         Y1ml/POfZhDOc/RLhSJLs0YaD0ZEn7gNj4ypwSVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: [PATCH 5.4 049/177] usb: core: urb: fix URB structure initialization function
Date:   Mon, 16 Dec 2019 18:48:25 +0100
Message-Id: <20191216174830.277679565@linuxfoundation.org>
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

From: Emiliano Ingrassia <ingrassia@epigenesys.com>

commit 1cd17f7f0def31e3695501c4f86cd3faf8489840 upstream.

Explicitly initialize URB structure urb_list field in usb_init_urb().
This field can be potentially accessed uninitialized and its
initialization is coherent with the usage of list_del_init() in
usb_hcd_unlink_urb_from_ep() and usb_giveback_urb_bh() and its
explicit initialization in usb_hcd_submit_urb() error path.

Signed-off-by: Emiliano Ingrassia <ingrassia@epigenesys.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191127160355.GA27196@ingrassia.epigenesys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/urb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -45,6 +45,7 @@ void usb_init_urb(struct urb *urb)
 	if (urb) {
 		memset(urb, 0, sizeof(*urb));
 		kref_init(&urb->kref);
+		INIT_LIST_HEAD(&urb->urb_list);
 		INIT_LIST_HEAD(&urb->anchor_list);
 	}
 }


