Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818681D825F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgERRzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgERRzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4BC20853;
        Mon, 18 May 2020 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824550;
        bh=t+cVUEWBAPXsQjH+Tn8Zh++09MrccH0dYs2jgv7JMb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oyFJrauC9TtcpW84iDXstrfnjSyd070kJtEX/3ElG8JGslztorWcHUlMXEJSFYJ3
         SDc4mZ+WQ/wT9EbtWZP9f/qNa4qMETil/dLNiPTtXEC0XZ0Rmr30GZ1iYdVggR3naC
         1aGh8Uh3R6OLyYV2/G6sQfGGTS1hQfHJ7u/iCurI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/147] pinctrl: sunrisepoint: Fix PAD lock register offset for SPT-H
Date:   Mon, 18 May 2020 19:36:19 +0200
Message-Id: <20200518173520.948346356@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6b7275c87717652daace4c0b8131eb184c7d7516 ]

It appears that SPT-H variant has different offset for PAD locking registers.
Fix it here.

Fixes: 551fa5801ef1 ("pinctrl: intel: sunrisepoint: Add Intel Sunrisepoint-H support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
index d936e7aa74c4b..7b7736abe9d86 100644
--- a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
+++ b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
@@ -15,17 +15,18 @@
 
 #include "pinctrl-intel.h"
 
-#define SPT_PAD_OWN	0x020
-#define SPT_PADCFGLOCK	0x0a0
-#define SPT_HOSTSW_OWN	0x0d0
-#define SPT_GPI_IS	0x100
-#define SPT_GPI_IE	0x120
+#define SPT_PAD_OWN		0x020
+#define SPT_H_PADCFGLOCK	0x090
+#define SPT_LP_PADCFGLOCK	0x0a0
+#define SPT_HOSTSW_OWN		0x0d0
+#define SPT_GPI_IS		0x100
+#define SPT_GPI_IE		0x120
 
 #define SPT_COMMUNITY(b, s, e)				\
 	{						\
 		.barno = (b),				\
 		.padown_offset = SPT_PAD_OWN,		\
-		.padcfglock_offset = SPT_PADCFGLOCK,	\
+		.padcfglock_offset = SPT_LP_PADCFGLOCK,	\
 		.hostown_offset = SPT_HOSTSW_OWN,	\
 		.is_offset = SPT_GPI_IS,		\
 		.ie_offset = SPT_GPI_IE,		\
@@ -47,7 +48,7 @@
 	{						\
 		.barno = (b),				\
 		.padown_offset = SPT_PAD_OWN,		\
-		.padcfglock_offset = SPT_PADCFGLOCK,	\
+		.padcfglock_offset = SPT_H_PADCFGLOCK,	\
 		.hostown_offset = SPT_HOSTSW_OWN,	\
 		.is_offset = SPT_GPI_IS,		\
 		.ie_offset = SPT_GPI_IE,		\
-- 
2.20.1



