Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6628214E1FD
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgA3SsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgA3SsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF8A214AF;
        Thu, 30 Jan 2020 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410099;
        bh=xjiIuT2evy8epx2GISn700fzYHTLGE7gpt2NB0cwO60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+bp+omCD/y8+9g7FEGfYefSz5/N1EqCc6YhbhjIEghglR2PO+palJzX31E+k/xyZ
         bk6JcLB9fDm5dW3GkaJOSiSVP7MWLyPntU15KyYRl7Fawuaosh9LApWMmwJf4RrCeI
         nZV73U60hw7bb6cif2fgE7bdQvos7tDERrr3i8XE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Ellis <sellis@redhat.com>,
        Pacho Ramos <pachoramos@gmail.com>,
        Laura Abbott <labbott@fedoraproject.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/55] usb-storage: Disable UAS on JMicron SATA enclosure
Date:   Thu, 30 Jan 2020 19:39:26 +0100
Message-Id: <20200130183616.725138931@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d0bdebd87ce3a..1b23741036ee8 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -87,12 +87,15 @@ UNUSUAL_DEV(0x2537, 0x1068, 0x0000, 0x9999,
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



