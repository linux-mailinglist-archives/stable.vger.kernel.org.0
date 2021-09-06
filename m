Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2718C40127E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhIFBVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238678AbhIFBVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FAE61054;
        Mon,  6 Sep 2021 01:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891204;
        bh=veOS5DcXdyQJknDpPh/8VSiDRyNRrBRvHEsD4+NfVFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQeOYbnRsgn4OQcIxnGuZ0XsuKhK+SFRlWodGe/rLFFP501DH0vkIa26geOpzkZ52
         JhQrCQhvpNVnLDbUAEnPo1JCvofTf/7llAKDtpCjabDZ6b7yV0nCgqD6aomLiAkifA
         YBniHSWols8CqhU4Duup+z//EVJik9bbyeG1IM4FbIduHCmBe+i5aC4Wp3HOIkX5TU
         2FABGu7IVoP9IWamago0h4T/AGKDhA0gWDWjXVym+lhJYszhPCOZjdYgMs+MtWNqJd
         KU1Sm1ztvQBKnVve7SkFKQ+coclmDdlmenSSwfFcwITgy14GHCcF2BMdxcm5KuoJvX
         grNnYYWAdojXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/47] EDAC/mce_amd: Do not load edac_mce_amd module on guests
Date:   Sun,  5 Sep 2021 21:19:14 -0400
Message-Id: <20210906011951.928679-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

[ Upstream commit 767f4b620edadac579c9b8b6660761d4285fa6f9 ]

Hypervisors likely do not expose the SMCA feature to the guest and
loading this module leads to false warnings. This module should not be
loaded in guests to begin with, but people tend to do so, especially
when testing kernels in VMs. And then they complain about those false
warnings.

Do the practical thing and do not load this module when running as a
guest to avoid all that complaining.

 [ bp: Rewrite commit message. ]

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lkml.kernel.org/r/20210628172740.245689-1-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/mce_amd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 27d56920b469..67dbf4c31271 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1246,6 +1246,9 @@ static int __init mce_amd_init(void)
 	    c->x86_vendor != X86_VENDOR_HYGON)
 		return -ENODEV;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	if (boot_cpu_has(X86_FEATURE_SMCA)) {
 		xec_mask = 0x3f;
 		goto out;
-- 
2.30.2

