Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B113FD7F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbgAPX0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388435AbgAPX0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582832072B;
        Thu, 16 Jan 2020 23:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217192;
        bh=mEUvSOU2Akh+cScg+BBUAWEU3flXvD51J2Fu0jvxCSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfEihrM70HSkhbZtM651AuYZPmCeS94ZNoNS2lzmlg+ijQkBiLDpzt0qyNcXkNK7S
         mallynZuie8xEwAVgOUepqg9fMMdRgiv0zovoZg5ECz6r2iZ/JPAhoCx15fqTvs7BN
         5iekWMIA9DSTT63kXwBOx8O2P10WA1IBiFVzZP2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anan Sun <anan.sun@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 161/203] memory: mtk-smi: Add PM suspend and resume ops
Date:   Fri, 17 Jan 2020 00:17:58 +0100
Message-Id: <20200116231758.801694068@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

commit fb03082a54acd66c61535edfefe96b2ff88ce7e2 upstream.

In the commit 4f0a1a1ae351 ("memory: mtk-smi: Invoke pm runtime_callback
to enable clocks"), we use pm_runtime callback to enable/disable the smi
larb clocks. It will cause the larb's clock may not be disabled when
suspend. That is because device_prepare will call pm_runtime_get_noresume
which will keep the larb's PM runtime status still is active when suspend,
then it won't enter our pm_runtime suspend callback to disable the
corresponding clocks.

This patch adds suspend pm_ops to force disable the clocks, Use "LATE" to
make sure it disable the larb's clocks after the multimedia devices.

Fixes: 4f0a1a1ae351 ("memory: mtk-smi: Invoke pm runtime_callback to enable clocks")
Signed-off-by: Anan Sun <anan.sun@mediatek.com>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/mtk-smi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -366,6 +366,8 @@ static int __maybe_unused mtk_smi_larb_s
 
 static const struct dev_pm_ops smi_larb_pm_ops = {
 	SET_RUNTIME_PM_OPS(mtk_smi_larb_suspend, mtk_smi_larb_resume, NULL)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				     pm_runtime_force_resume)
 };
 
 static struct platform_driver mtk_smi_larb_driver = {
@@ -507,6 +509,8 @@ static int __maybe_unused mtk_smi_common
 
 static const struct dev_pm_ops smi_common_pm_ops = {
 	SET_RUNTIME_PM_OPS(mtk_smi_common_suspend, mtk_smi_common_resume, NULL)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				     pm_runtime_force_resume)
 };
 
 static struct platform_driver mtk_smi_common_driver = {


