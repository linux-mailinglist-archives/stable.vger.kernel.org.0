Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51062A398C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgKCB0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgKCBTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563FD2240C;
        Tue,  3 Nov 2020 01:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366376;
        bh=fu1X88HwblEGyDKmT0nXc63ooYPumtIElocBOMRl/WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlnhPEfHidTG1F+twV5KbaEX5v/sY5KLOkrpipmhoBvOs5gQKwtZFDcNbP+9ZSlL9
         uyhp2tNmskTvOwHBJBuoJZHNyzhbNIoQM4nM38kljoO7R70egQYRfHJoFVJayrWoBb
         mQj2GfqlYv95GkUlmSI+1otwun8dtpq7SUQBCB84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kairui Song <kasong@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 06/29] x86/kexec: Use up-to-dated screen_info copy to fill boot params
Date:   Mon,  2 Nov 2020 20:19:05 -0500
Message-Id: <20201103011928.183145-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kairui Song <kasong@redhat.com>

[ Upstream commit afc18069a2cb7ead5f86623a5f3d4ad6e21f940d ]

kexec_file_load() currently reuses the old boot_params.screen_info,
but if drivers have change the hardware state, boot_param.screen_info
could contain invalid info.

For example, the video type might be no longer VGA, or the frame buffer
address might be changed. If the kexec kernel keeps using the old screen_info,
kexec'ed kernel may attempt to write to an invalid framebuffer
memory region.

There are two screen_info instances globally available, boot_params.screen_info
and screen_info. Later one is a copy, and is updated by drivers.

So let kexec_file_load use the updated copy.

[ mingo: Tidied up the changelog. ]

Signed-off-by: Kairui Song <kasong@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20201014092429.1415040-2-kasong@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kexec-bzimage64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index db6578d45157e..7d520bada6bfc 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -209,8 +209,7 @@ setup_boot_parameters(struct kimage *image, struct boot_params *params,
 	params->hdr.hardware_subarch = boot_params.hdr.hardware_subarch;
 
 	/* Copying screen_info will do? */
-	memcpy(&params->screen_info, &boot_params.screen_info,
-				sizeof(struct screen_info));
+	memcpy(&params->screen_info, &screen_info, sizeof(struct screen_info));
 
 	/* Fill in memsize later */
 	params->screen_info.ext_mem_k = 0;
-- 
2.27.0

