Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0705544B76E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbhKIWfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344596AbhKIWce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758D461AAB;
        Tue,  9 Nov 2021 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496488;
        bh=KuL1HRKhik+WKf2RNszvAZoVoJNEj6Cwls/EwSaYfuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdHiw5LLGxKregyi2C4cWRv6CnlICm+05tUayRC0wpKxBXXO256hRS94YvZPWEyc1
         5auIRCcLfSQZNWkzybUKnRwz3VePxWnOZ9S6XFJvEK43Vu9oiQoCOPNlecL+NaLDlu
         8fQUpji8x8A7fMQQE6ZlpVfoeDXSrpQl/IhJh2Ueks0o1B2ni5pOOQhUqTGU9tMvZS
         C9uoxYRU3qFXI6FMYoRgBEu36p6ArKM8TZ5oxES4IaRaB+8A5xmnXUaizGRpRNJ75r
         e9bBR3ufVQT+Vlnd4svQOc/OtxoY+impCo/yVRxF+n3JpMKb8MDdeFQxMBgIBJdIUs
         cesIKSFE/9akA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 14/50] bus: ti-sysc: Use context lost quirks for gpmc
Date:   Tue,  9 Nov 2021 17:20:27 -0500
Message-Id: <20211109222103.1234885-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit d48dca51935b8ca13356e726442c21ec94668d69 ]

At least on am335x, the gpmc module needs a re-init and reset if context
has been lost on resume. We can enable this for all gpmc revisions as we
check if the context was lost before restoring it.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index b3f4c1e7a4e86..5876293d493a9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1488,6 +1488,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("gpmc", 0, 0, 0x10, 0x14, 0x00000060, 0xffffffff,
+		   SYSC_QUIRK_REINIT_ON_CTX_LOST | SYSC_QUIRK_RESET_ON_CTX_LOST |
 		   SYSC_QUIRK_GPMC_DEBUG),
 	SYSC_QUIRK("hdmi", 0, 0, 0x10, -ENODEV, 0x50030200, 0xffffffff,
 		   SYSC_QUIRK_OPT_CLKS_NEEDED),
-- 
2.33.0

