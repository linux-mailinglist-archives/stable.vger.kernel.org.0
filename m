Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A182AB985
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgKINKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731963AbgKINKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9C992083B;
        Mon,  9 Nov 2020 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927400;
        bh=1F4wsseaD7dA/55JAb7Imc6P+6gBNObou4dyyvIU1mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrCiOPOBTcph0Z6VdQ+Mtx73pnshA9GgLerCehkfcdA5AclNOQdjnnzz3cArL19lQ
         Qu61KOSulLnuMUJSFCOIdgKVD0WhFwXXXR4npoZPxgzSvNE3N7wdSuuWU5/7d7Kq8C
         COjURNu5qZrmTVRucpfBL2mRamQWqDotauBsVAho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kairui Song <kasong@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/71] x86/kexec: Use up-to-dated screen_info copy to fill boot params
Date:   Mon,  9 Nov 2020 13:55:41 +0100
Message-Id: <20201109125022.110384129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9490a2845f14b..273687986a263 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -211,8 +211,7 @@ setup_boot_parameters(struct kimage *image, struct boot_params *params,
 	params->hdr.hardware_subarch = boot_params.hdr.hardware_subarch;
 
 	/* Copying screen_info will do? */
-	memcpy(&params->screen_info, &boot_params.screen_info,
-				sizeof(struct screen_info));
+	memcpy(&params->screen_info, &screen_info, sizeof(struct screen_info));
 
 	/* Fill in memsize later */
 	params->screen_info.ext_mem_k = 0;
-- 
2.27.0



