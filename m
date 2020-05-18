Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970EF1D8675
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgERRqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgERRqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 084BC207C4;
        Mon, 18 May 2020 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823969;
        bh=vNZivytMBWAhlteQOYiqnhPyfZQnjhltAJXHLe92+kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6wlbgO2kk6/C8vKuorkoTYvwLLpdb0k+7VYK1BCHtxciRpCSFSi5ydb20NFzo8/D
         zNDYSw9eO6F1sG43znGVI61Nm/DZ1ZxsEaY9BavJJvuAPCjhsvz9RAz0wkS4oQm5ri
         gPal0BM4D37j4Q4/x8RaPoep6wbCpXpuPw9pPVY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        =?UTF-8?q?Julian=20Gro=C3=9F?= <julian.g@posteo.de>
Subject: [PATCH 4.14 019/114] USB: uas: add quirk for LaCie 2Big Quadra
Date:   Mon, 18 May 2020 19:35:51 +0200
Message-Id: <20200518173507.149711736@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 9f04db234af691007bb785342a06abab5fb34474 upstream.

This device needs US_FL_NO_REPORT_OPCODES to avoid going
through prolonged error handling on enumeration.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Julian Groß <julian.g@posteo.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200429155218.7308-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -41,6 +41,13 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
  */
 
+/* Reported-by: Julian Groß <julian.g@posteo.de> */
+UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
+		"LaCie",
+		"2Big Quadra USB3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?


