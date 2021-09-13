Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D418409365
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbhIMOVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344198AbhIMOSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E447161502;
        Mon, 13 Sep 2021 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540726;
        bh=veOS5DcXdyQJknDpPh/8VSiDRyNRrBRvHEsD4+NfVFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivsji55mx5FHz1KmxzbYpwFyblaNgyR84hlPsW3g8i/09IHU0gmaV2Y/y6iwObsx9
         s59f/f/sggruvmdj/tCM4F9UXtDU+1RoWRsUVJX+FqoVujPyDLTA58qRTB54eJnXmf
         sBBUMrCYbVeaPo4W+uYJJYIfaXPER6C/sIlS9yUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 010/334] EDAC/mce_amd: Do not load edac_mce_amd module on guests
Date:   Mon, 13 Sep 2021 15:11:04 +0200
Message-Id: <20210913131113.751628936@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



