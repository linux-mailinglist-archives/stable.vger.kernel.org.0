Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F01EAE09
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgFASFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730379AbgFASFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C7D20872;
        Mon,  1 Jun 2020 18:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034752;
        bh=xe0N+7sYbFtwojUydJ8S15eOlZCR8+wuTi/LeGmYtAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMGV9K/7r0kkOAzTv4V32CUCyw3/bH1th1gkub4QHSIaaNlznqN2iJiNrnngF4IzI
         Duu5Si13sOKSBEUp3vyrf46MXYHFvbHDVMaP599Hjboo3ioiGXpOwP1Cj1Vf+uQ+cD
         bBOxJyzMDFsZw5nZXsPT+fD/1w5CymLj0r5Qr9MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 93/95] Revert "Input: i8042 - add ThinkPad S230u to i8042 nomux list"
Date:   Mon,  1 Jun 2020 19:54:33 +0200
Message-Id: <20200601174034.556745974@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f4dec2d6160976b14e54be9c3950ce0f52385741 upstream.

This reverts commit 18931506465a762ffd3f4803d36a18d336a67da9. From Kevin
Locke:

"... nomux only appeared to fix the issue because the controller
continued working after warm reboots. After more thorough testing from
both warm and cold start, I now believe the entry should be added to
i8042_dmi_reset_table rather than i8042_dmi_nomux_table as i8042.reset=1
alone is sufficient to avoid the issue from both states while
i8042.nomux is not."

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -545,13 +545,6 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
 		},
 	},
-	{
-		/* Lenovo ThinkPad Twist S230u */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
-		},
-	},
 	{ }
 };
 


