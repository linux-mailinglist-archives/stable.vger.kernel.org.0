Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB8048005F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhL0Ppv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbhL0PoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EFDDB810C5;
        Mon, 27 Dec 2021 15:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2585EC36AEA;
        Mon, 27 Dec 2021 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619850;
        bh=7CvqLTU0SnFLvZhWqamFCCCVPEv15CcrecQyE0GsY9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+Q6CI/BFPGnsode7kuBFk0x9tj+lKaA87pkWC0t8SslUfpHwJ2IYk3kLN/giZ2ZL
         PlSnvMXGLi4n2yXr0uAVL2HyYCvQUfzK96vUNeaeTrl98zTvxytrWrNbXw7MEtQlQ9
         83xD18PoV5qqNd5mpMsoPLnApbirVbtuwFSK/r6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 084/128] platform/x86: amd-pmc: only use callbacks for suspend
Date:   Mon, 27 Dec 2021 16:30:59 +0100
Message-Id: <20211227151334.313259104@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 09fc14061f3ed28899c23b8714c066946fdbd43e upstream.

This driver is intended to be used exclusively for suspend to idle
so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
at the wrong time leading to an undefined behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20211210143529.10594-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -375,7 +375,8 @@ static int __maybe_unused amd_pmc_resume
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
+	.suspend_noirq = amd_pmc_suspend,
+	.resume_noirq = amd_pmc_resume,
 };
 
 static const struct pci_device_id pmc_pci_ids[] = {


