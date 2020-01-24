Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50555147628
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgAXBSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAXBSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:18:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 672182253D;
        Fri, 24 Jan 2020 01:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828694;
        bh=wV3EqIuuGbB79eip1FqxumZ6nHGkbGQzO68Nyo5GlX8=;
        h=From:To:Cc:Subject:Date:From;
        b=y2uMTvV400lz4Zaz+5yt3GEKxrOSZWzEQOVc98ET+jfBi+jzY2l60etaopa5D1P9G
         olk+G9QQkZQDmUjfdUxS0zf/86RE65iGTpCNuGTzHXPrsu3TW8gDqx7UBx4vJQbxFG
         qRIhrTKYHumShi1LZe7sGOuDwYYbfzXhLQRg/Ol8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laura Abbott <labbott@fedoraproject.org>,
        Steven Ellis <sellis@redhat.com>,
        Pacho Ramos <pachoramos@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 4.4] usb-storage: Disable UAS on JMicron SATA enclosure
Date:   Thu, 23 Jan 2020 20:18:12 -0500
Message-Id: <20200124011812.18866-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@fedoraproject.org>

[ Upstream commit bc3bdb12bbb3492067c8719011576370e959a2e6 ]

Steve Ellis reported incorrect block sizes and alignement
offsets with a SATA enclosure. Adding a quirk to disable
UAS fixes the problems.

Reported-by: Steven Ellis <sellis@redhat.com>
Cc: Pacho Ramos <pachoramos@gmail.com>
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 8ed80f28416fa..9aad6825947c8 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -162,12 +162,15 @@ UNUSUAL_DEV(0x2537, 0x1068, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
-/* Reported-by: Takeo Nakayama <javhera@gmx.com> */
+/*
+ * Initially Reported-by: Takeo Nakayama <javhera@gmx.com>
+ * UAS Ignore Reported by Steven Ellis <sellis@redhat.com>
+ */
 UNUSUAL_DEV(0x357d, 0x7788, 0x0000, 0x9999,
 		"JMicron",
 		"JMS566",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_REPORT_OPCODES),
+		US_FL_NO_REPORT_OPCODES | US_FL_IGNORE_UAS),
 
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x4971, 0x1012, 0x0000, 0x9999,
-- 
2.20.1

