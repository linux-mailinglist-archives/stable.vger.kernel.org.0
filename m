Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4A24B607
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgHTKUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbgHTKUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:20:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36916206DA;
        Thu, 20 Aug 2020 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918812;
        bh=Gg+kEkswDRxTKOBGrIllN4zRgEO19H9gT8252jAy1aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRIQW/5wfyGfyi3Jg4qa9gKm1186ftY4RGGBqHFop82xp+WzzRcWgIQGR8CG8PVMw
         nJ9SJrz456m23LxVy0o5B/3b4hO3aaPEeA5PE8QhSQ3GWy9bhOzb3zZVJmdJk7fYV7
         jp/fotQS9R5sHPOkt6L2eOJTjarE+dTgIO4cJvH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 036/149] Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
Date:   Thu, 20 Aug 2020 11:21:53 +0200
Message-Id: <20200820092127.482844716@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 75bbd2ea50ba1c5d9da878a17e92eac02fe0fd3a upstream.

Check `num_rsp` before using it as for-loop counter.

Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2094,7 +2094,7 @@ static void hci_inquiry_result_evt(struc
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))


