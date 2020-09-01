Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5C259B64
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgIARBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbgIAPU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D3B206FA;
        Tue,  1 Sep 2020 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973659;
        bh=R+sy9+rbfVvRFi768ot2J0wZfyfxGXGm41rBOzJRWFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RByPfxZoKbebr1aI1l3/6GAE6BlYqBIVkFby2lKTpJHbdWm9phmAqZLcn/8RHDKsB
         hPmxiHMyaMez7MvYefW8Hy9/lTBVPQ+mR5vFmILjyJLih1I71s2v9duuoiLbKmbVoQ
         /Yb7lrSNhz1O0/rYQcmRgFume6QAvu65iRKK3xII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?q?Till=20D=C3=B6rges?= <doerges@pre-sense.de>
Subject: [PATCH 4.14 87/91] usb: storage: Add unusual_uas entry for Sony PSZ drives
Date:   Tue,  1 Sep 2020 17:11:01 +0200
Message-Id: <20200901150932.488804413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 20934c0de13b49a072fb1e0ca79fe0fe0e40eae5 upstream.

The PSZ-HA* family of USB disk drives from Sony can't handle the
REPORT OPCODES command when using the UAS protocol.  This patch adds
an appropriate quirks entry.

Reported-and-tested-by: Till Dörges <doerges@pre-sense.de>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200826143229.GB400430@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -41,6 +41,13 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
  */
 
+/* Reported-by: Till Dörges <doerges@pre-sense.de> */
+UNUSUAL_DEV(0x054c, 0x087d, 0x0000, 0x9999,
+		"Sony",
+		"PSZ-HA*",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Julian Groß <julian.g@posteo.de> */
 UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		"LaCie",


