Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F693A0389
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhFHTSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhFHTQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6A161960;
        Tue,  8 Jun 2021 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178245;
        bh=Xi1/ZXgIYQaevfg6XkjhzHOQlPgzBh15pOa3LvG6h9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g10hi5gULy5SMegf2ett1n6hxWoK5s1IEgTxVUK53f9dJ26eO3oSmCvilcxKxAELA
         FQ/RwwWzITsFN2bOZp6XVJlqEZwX6F1o3wvjOn0GQYMDUQkpub+UOXGC4fovl7kolI
         Hruqn0p8lroDezBJsBzvOm92YcjAcuDlVoNWJ1Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.12 131/161] dmaengine: idxd: Use cpu_feature_enabled()
Date:   Tue,  8 Jun 2021 20:27:41 +0200
Message-Id: <20210608175949.877758419@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 74b2fc882d380d8fafc2a26f01d401c2a7beeadb upstream.

When testing x86 feature bits, use cpu_feature_enabled() so that
build-disabled features can remain off, regardless of what CPUID says.

Fixes: 8e50d392652f ("dmaengine: idxd: Add shared workqueue support")
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-By: Vinod Koul <vkoul@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -675,12 +675,12 @@ static int __init idxd_init_module(void)
 	 * If the CPU does not support MOVDIR64B or ENQCMDS, there's no point in
 	 * enumerating the device. We can not utilize it.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_MOVDIR64B)) {
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_warn("idxd driver failed to load without MOVDIR64B.\n");
 		return -ENODEV;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_ENQCMD))
+	if (!cpu_feature_enabled(X86_FEATURE_ENQCMD))
 		pr_warn("Platform does not have ENQCMD(S) support.\n");
 	else
 		support_enqcmd = true;


