Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACB02F515
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfE3EoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbfE3DMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34655244D6;
        Thu, 30 May 2019 03:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185922;
        bh=+3kSHClLptg6DesRS/me8pwXtVYyalM2f39uqBqGRao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyHf5T4u6wMm+gGIyIjslYVp0/sckcuIeLH3NgiCtfUJqnePekTZJFMHlBj1Oa7Wk
         3UN3GBsrwq+Vutkl6ThR+XMr6wYTfIFJeLgRInYTygIbPnBwcb1zAvK9TauF5rLXNr
         8hrgUsafkpDmCpiRIEhf1zzSDtaNYnOBEhy1+JDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Borislav Petkov <bp@suse.de>, Andrew Banman <abanman@hpe.com>,
        Andy Shevchenko <andy@infradead.org>,
        Colin Ian King <colin.king@canonical.com>,
        Darren Hart <dvhart@infradead.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Mike Travis <mike.travis@hpe.com>,
        Nicolai Stange <nstange@suse.de>, pakki001@umn.edu,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Varsha Rao <rvarsha016@gmail.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 310/405] x86/platform/uv: Fix missing checks of kcalloc() return values
Date:   Wed, 29 May 2019 20:05:08 -0700
Message-Id: <20190530030556.486305232@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 766460852cfaeca4042e5f3aeb9616b3689147bc ]

Handle potential errors returned from kcalloc().

 [ bp: rewrite commit message. ]

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andrew Banman <abanman@hpe.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Nicolai Stange <nstange@suse.de>
Cc: pakki001@umn.edu
Cc: platform-driver-x86@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Varsha Rao <rvarsha016@gmail.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190325202924.4624-1-kjlu@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/uv/tlb_uv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 2c53b0f19329a..1297e185b8c8d 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -2133,14 +2133,19 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
  */
 static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
 {
-	unsigned char *uvhub_mask;
 	struct uvhub_desc *uvhub_descs;
+	unsigned char *uvhub_mask = NULL;
 
 	if (is_uv3_hub() || is_uv2_hub() || is_uv1_hub())
 		timeout_us = calculate_destination_timeout();
 
 	uvhub_descs = kcalloc(nuvhubs, sizeof(struct uvhub_desc), GFP_KERNEL);
+	if (!uvhub_descs)
+		goto fail;
+
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
+	if (!uvhub_mask)
+		goto fail;
 
 	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
 		goto fail;
-- 
2.20.1



