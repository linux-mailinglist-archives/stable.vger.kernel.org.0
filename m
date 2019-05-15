Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004281EE7D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfEOLW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731447AbfEOLW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628CF20843;
        Wed, 15 May 2019 11:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919345;
        bh=ic2X2wucdWAIqyc+kMQUO+l9ciH1tOKalvmRNY0QTWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+6gFNMhMur9JCPwpY12645G3H3V/f2QIuJOt2u2U65AGyY/Vmd2eD8a2UQPHNIHV
         FQA4oYSvBntO2tMMHj5/i1D53pBoKLL4OOEDGmyDzy8+kNxOQ3APZgIJJHmJFRdWnj
         WYDPuIdyiRNbwr42hoa2xtwE142rL7icRFfhdsMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pepijn de Vos <pepijndevos@gmail.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "Darren Hart (VMware)" <dvhart@infradead.org>
Subject: [PATCH 4.19 004/113] platform/x86: dell-laptop: fix rfkill functionality
Date:   Wed, 15 May 2019 12:54:55 +0200
Message-Id: <20190515090653.362635170@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

commit 6cc13c28da5beee0f706db6450e190709700b34a upstream.

When converting the driver two arguments were transposed leading
to rfkill not working.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201427
Reported-by: Pepijn de Vos <pepijndevos@gmail.com>
Fixes: 549b49 ("platform/x86: dell-smbios: Introduce dispatcher for SMM calls")
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Acked-by: Pali Rohár <pali.rohar@gmail.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/dell-laptop.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -532,7 +532,7 @@ static void dell_rfkill_query(struct rfk
 		return;
 	}
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 	hwswitch = buffer.output[1];
 
@@ -563,7 +563,7 @@ static int dell_debugfs_show(struct seq_
 		return ret;
 	status = buffer.output[1];
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	hwswitch_ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 	if (hwswitch_ret)
 		return hwswitch_ret;
@@ -648,7 +648,7 @@ static void dell_update_rfkill(struct wo
 	if (ret != 0)
 		return;
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 
 	if (ret == 0 && (status & BIT(0)))


