Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04122F130C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbhAKNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbhAKNCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:02:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737CF2251F;
        Mon, 11 Jan 2021 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370116;
        bh=dUErXp/SWhpDo6ZZNPnEl8bhszyk8ag0fqc8gzI25q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WgwdPWLkASyUHfCfgWHaMdKesyjV4YwK0C6kuns+krQ1OQwDJQPOGyIR1osOUmb2
         eIpG9j39MxdSMsPxlYWNrmI4NBE3lhjPs06fShUbu5pgB8uR6GPi84B4ULE01QwcJL
         bnjVFdkiyz3H+RmRzTCQuWjSznlHguWHrc2BoMYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.4 20/38] usb: uas: Add PNY USB Portable SSD to unusual_uas
Date:   Mon, 11 Jan 2021 14:00:52 +0100
Message-Id: <20210111130033.442984599@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 96ebc9c871d8a28fb22aa758dd9188a4732df482 upstream.

Here's another variant PNY Pro Elite USB 3.1 Gen 2 portable SSD that
hangs and doesn't respond to ATA_1x pass-through commands. If it doesn't
support these commands, it should respond properly to the host. Add it
to the unusual uas list to be able to move forward with other
operations.

Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/2edc7af892d0913bf06f5b35e49ec463f03d5ed8.1609819418.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -163,6 +163,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x99
 		US_FL_BROKEN_FUA),
 
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
+UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
+		"PNY",
+		"Pro Elite SSD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
+/* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
 		"PNY",
 		"Pro Elite SSD",


