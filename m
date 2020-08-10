Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC3240892
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgHJPWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgHJPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:22:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA72520656;
        Mon, 10 Aug 2020 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072953;
        bh=Koqr+g0K/h5hFhzzvLXgmLoyN5/Ry7tVmPiAqi1K72M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUmdXmCksQv13EfbiRnOzc8DipIZ+x9JbrYr/cigzVZmerLjA5gwkIPrF+LMEBaab
         m0kybR4TR1BLCZhb3AcNSYUxZOUqwUT46sCnZB5jrxmBYuEbTllE+O7UBCSGP1DdRs
         wORiW/FbiZDJdjFo6gbG7btkD7Be29PNbbFvnMfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.7 16/79] Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
Date:   Mon, 10 Aug 2020 17:20:35 +0200
Message-Id: <20200810151812.923444639@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
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
@@ -2487,7 +2487,7 @@ static void hci_inquiry_result_evt(struc
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))


