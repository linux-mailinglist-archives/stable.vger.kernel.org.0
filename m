Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C8B2409F4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgHJPhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgHJP0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C09E20772;
        Mon, 10 Aug 2020 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073192;
        bh=PsV4Wdex9Sq7veb+qcwLect4hPlK6NbXRYPPW/MCsLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2uK+9jH2gejGmFeM0YodMh8lIbqBr22+lBkFdgs8Jx+s2MvWe79y0sEPPBGXIlo7
         XHbrBAlHw7R5i1LXyVAiCtfn+iQx6E9of3AyUEAwOb5dWcXAf27rQlERfVUCXRrhRd
         yKSXTgyqyB4FdtfIa6t55wQMu3gJSVB3XaOVw1ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 19/67] Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()
Date:   Mon, 10 Aug 2020 17:21:06 +0200
Message-Id: <20200810151810.372729922@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
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
@@ -4067,6 +4067,9 @@ static void hci_inquiry_result_with_rssi
 		struct inquiry_info_with_rssi_and_pscan_mode *info;
 		info = (void *) (skb->data + 1);
 
+		if (skb->len < num_rsp * sizeof(*info) + 1)
+			goto unlock;
+
 		for (; num_rsp; num_rsp--, info++) {
 			u32 flags;
 
@@ -4088,6 +4091,9 @@ static void hci_inquiry_result_with_rssi
 	} else {
 		struct inquiry_info_with_rssi *info = (void *) (skb->data + 1);
 
+		if (skb->len < num_rsp * sizeof(*info) + 1)
+			goto unlock;
+
 		for (; num_rsp; num_rsp--, info++) {
 			u32 flags;
 
@@ -4108,6 +4114,7 @@ static void hci_inquiry_result_with_rssi
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 


