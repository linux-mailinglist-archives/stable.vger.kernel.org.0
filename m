Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4626A14BB66
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgA1ODK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgA1ODK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1964D24683;
        Tue, 28 Jan 2020 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220189;
        bh=L5b7E28Fmf+Ro7wfsy7cxFoBjNsdh/r3wjnSveHbKRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5Uqg7iTe7PLQ0m4eX5qgjVRvTTdeWR4xdHWB5YzY5mXlFWjYaSoIprmDbQyCIXvW
         oLNfuv2KNZK1AlitkLFcr0+mogQLPq167mL2nM9MCYrgUq0u50oPEVUfScu7U6Fq9P
         2QkI1ZKNJcji3sBWIHzVBiE3TP0xH2DijobpRBFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boyan Ding <boyan.j.ding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 053/104] pinctrl: sunrisepoint: Add missing Interrupt Status register offset
Date:   Tue, 28 Jan 2020 15:00:14 +0100
Message-Id: <20200128135824.958262197@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boyan Ding <boyan.j.ding@gmail.com>

commit 9608ea6c6613ced75b2c41703d99f44e6f8849f1 upstream.

Commit 179e5a6114cc ("pinctrl: intel: Remove default Interrupt Status
offset") removes default interrupt status offset of GPIO controllers,
with previous commits explicitly providing the previously default
offsets. However, the is_offset value in SPTH_COMMUNITY is missing,
preventing related irq from being properly detected and handled.

Fixes: f702e0b93cdb ("pinctrl: sunrisepoint: Provide Interrupt Status register offset")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205745
Cc: stable@vger.kernel.org
Signed-off-by: Boyan Ding <boyan.j.ding@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
+++ b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
@@ -49,6 +49,7 @@
 		.padown_offset = SPT_PAD_OWN,		\
 		.padcfglock_offset = SPT_PADCFGLOCK,	\
 		.hostown_offset = SPT_HOSTSW_OWN,	\
+		.is_offset = SPT_GPI_IS,		\
 		.ie_offset = SPT_GPI_IE,		\
 		.pin_base = (s),			\
 		.npins = ((e) - (s) + 1),		\


