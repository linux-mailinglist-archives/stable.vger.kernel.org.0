Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838D637C3A1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhELPVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhELPSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC5A61434;
        Wed, 12 May 2021 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832064;
        bh=ERHstO4VURucCm/aMeQ0hymlhFLSb4PSENuyxNM/sdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IDg0i5tcjLyDiCCs7HzPWakHRhWEFuTAxl/eduQstdTKtjHYgfvW3BaMK6n5v1eC
         bnKAamIadoLguIrnNBx0oCNMmt6pvWIEsjoVAprfgcqPT1Hf4UKhJ8Eg8eQYhiJgBv
         7GmmLF7EoJWMEPeNVXurjhNJNEJ76wAx4zEuVJvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Travis <mike.travis@hpe.com>,
        Borislav Petkov <bp@suse.de>, Steve Wahl <steve.wahl@hpe.com>,
        Russ Anderson <rja@hpe.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/530] x86/platform/uv: Set section block size for hubless architectures
Date:   Wed, 12 May 2021 16:43:57 +0200
Message-Id: <20210512144823.988251997@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Travis <mike.travis@hpe.com>

[ Upstream commit 6840a150b9daf35e4d21ab9780d0a03b4ed74a5b ]

Commit

  bbbd2b51a2aa ("x86/platform/UV: Use new set memory block size function")

added a call to set the block size value that is needed by the kernel
to set the boundaries in the section list. This was done for UV Hubbed
systems but missed in the UV Hubless setup. Fix that mistake by adding
that same set call for hubless systems, which support the same NVRAMs
and Intel BIOS, thus the same problem occurs.

 [ bp: Massage commit message. ]

Fixes: bbbd2b51a2aa ("x86/platform/UV: Use new set memory block size function")
Signed-off-by: Mike Travis <mike.travis@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Russ Anderson <rja@hpe.com>
Link: https://lkml.kernel.org/r/20210305162853.299892-1-mike.travis@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 235f5cde06fc..40f466de8924 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1652,6 +1652,9 @@ static __init int uv_system_init_hubless(void)
 	if (rc < 0)
 		return rc;
 
+	/* Set section block size for current node memory */
+	set_block_size();
+
 	/* Create user access node */
 	if (rc >= 0)
 		uv_setup_proc_files(1);
-- 
2.30.2



