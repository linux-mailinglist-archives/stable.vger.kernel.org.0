Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AC6126A58
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfLSSqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfLSSqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:46:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A14F424693;
        Thu, 19 Dec 2019 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781175;
        bh=D88LjePSLbN6EE5u40F5tQyTS+zORMtNJIcWViBXcHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDbJX2HVCwtSZHg2JaV69aHUlbXtLNDUR8jZaMVmiXgweiMMs4Y5fmDS9a3/sjCJd
         RwEq1NAXzoEX4mHfOn2nzUkEc+7BidWfRBLUXYUHj4I0XMk56o70xwA7u+TdMO6Kju
         bL4AHUCc757oVXWpAxRBKMMvx6h/4ZOOys9hrr3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: [PATCH 4.9 112/199] usb: core: urb: fix URB structure initialization function
Date:   Thu, 19 Dec 2019 19:33:14 +0100
Message-Id: <20191219183221.072599924@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
@@ -40,6 +40,7 @@ void usb_init_urb(struct urb *urb)
 	if (urb) {
 		memset(urb, 0, sizeof(*urb));
 		kref_init(&urb->kref);
+		INIT_LIST_HEAD(&urb->urb_list);
 		INIT_LIST_HEAD(&urb->anchor_list);
 	}
 }


