Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3394012EF
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhIFBXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239215AbhIFBWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B1D6103C;
        Mon,  6 Sep 2021 01:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891264;
        bh=DFCKCt68zrCYytvMVBUKstE764z7KYylps4wylWcADI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0a4EXkJq1+2rS/cbBaS4MYH7ISgkG0nh3ggNjO3ABg3TujkQYIk+UoH86lahOxaj
         QZkejX9Ik30GSOjejfZZ+PfiByG2sV/lnC+r8mZ4eHpU3sXqxpE2/ykVHI2A7WFJ9n
         KtahzkpP/Yb5uuFyOuxJEVamEf9a5k8s5EWRnh4ZpeeE0yERqAN0of6nAgG6QrFFVF
         qXr/E3S82gohk1dBRtBZNZKVQ5wfI7wiBGb3oedq+3zv6hGDRkPXoL7V8C9YCeRdZ7
         k1YqgQXLAoO4lBmPb6QvT9lipOjzW4fgbb89iaLWUkLRC2ymITjs0TRAsTqKDRIkeE
         fpHZJvsSYVUMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/46] EDAC/mce_amd: Do not load edac_mce_amd module on guests
Date:   Sun,  5 Sep 2021 21:20:15 -0400
Message-Id: <20210906012052.929174-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index 5dd905a3f30c..1a1629166aa3 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1176,6 +1176,9 @@ static int __init mce_amd_init(void)
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

