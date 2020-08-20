Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334FD24B423
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgHTJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730409AbgHTJ6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D9622B3F;
        Thu, 20 Aug 2020 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917512;
        bh=2LkuLw7hc5amWcJudiBTDsOVkeurjDE/qsPZWPVYzm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGrGVB4pf90/PZfr3BIUHtjcoYGs0KD8GLv4Ph1KGzjR0LOPAT73G9nt5MWyZsJfh
         biKJL+Z1ZSLdKHj+0yPuEucONHgKCNfpyFhZhHwS4LfGvVCWzM7TMGSmt1ryi2OyrF
         JuUatsOD9uErv3GysrqKrkmH9aaoXSPsuuGQPzxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.9 056/212] Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()
Date:   Thu, 20 Aug 2020 11:20:29 +0200
Message-Id: <20200820091605.201121887@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 629b49c848ee71244203934347bd7730b0ddee8d upstream.

Check `num_rsp` before using it as for-loop counter. Add `unlock` label.

Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3623,6 +3623,9 @@ static void hci_inquiry_result_with_rssi
 		struct inquiry_info_with_rssi_and_pscan_mode *info;
 		info = (void *) (skb->data + 1);
 
+		if (skb->len < num_rsp * sizeof(*info) + 1)
+			goto unlock;
+
 		for (; num_rsp; num_rsp--, info++) {
 			u32 flags;
 
@@ -3644,6 +3647,9 @@ static void hci_inquiry_result_with_rssi
 	} else {
 		struct inquiry_info_with_rssi *info = (void *) (skb->data + 1);
 
+		if (skb->len < num_rsp * sizeof(*info) + 1)
+			goto unlock;
+
 		for (; num_rsp; num_rsp--, info++) {
 			u32 flags;
 
@@ -3664,6 +3670,7 @@ static void hci_inquiry_result_with_rssi
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 


