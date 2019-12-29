Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F812C917
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387498AbfL2R75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387463AbfL2R6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D81206DB;
        Sun, 29 Dec 2019 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642287;
        bh=nFsxqlSW5MdU86iOP42+FaKJBOzsfHU8mpAvyNypAEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYiSFv97SUY55HJhBTGPXtyGPJaY3JUvOMb0Bk0bO2cVK7eL/s/mabs4KkUavknTG
         tqqV7w9oXxfzWaU+fcTlMzMhVoe4zIaIS7Ri0a9fxcbyF53lw+WOanhZM0VAT5E+aF
         Gpc43ICtrhh+HZu7kyogWwHtZxkwNfPRMhkroUmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 377/434] can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices
Date:   Sun, 29 Dec 2019 18:27:10 +0100
Message-Id: <20191229172727.132515054@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

commit da2311a6385c3b499da2ed5d9be59ce331fa93e9 upstream.

Uninitialized Kernel memory can leak to USB devices.

Fix this by using kzalloc() instead of kmalloc().

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Fixes: 7259124eac7d ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
Cc: linux-stable <stable@vger.kernel.org> # >= v4.19
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -608,7 +608,7 @@ static int kvaser_usb_leaf_simple_cmd_as
 	struct kvaser_cmd *cmd;
 	int err;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1140,7 +1140,7 @@ static int kvaser_usb_leaf_set_opt_mode(
 	struct kvaser_cmd *cmd;
 	int rc;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1206,7 +1206,7 @@ static int kvaser_usb_leaf_flush_queue(s
 	struct kvaser_cmd *cmd;
 	int rc;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 


