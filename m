Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E427499FCF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842197AbiAXXBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456644AbiAXWjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6959BC04D61A;
        Mon, 24 Jan 2022 13:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31945B8105C;
        Mon, 24 Jan 2022 21:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5CFC340E5;
        Mon, 24 Jan 2022 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058253;
        bh=sLeBLzFgVT8t1e9qRMlDmM/Em1aCfW1X4MlX6q4CEq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTFwCVIalOb6G4HDq8ITDUNt4JpKZqm2fqyR8BtPaRtpR0YRUrQ5qyaCPxXgCizEz
         zxGpy4IlL7jbNo8cvUUQeMSXD5KFtEwVpCdJBLFzlARcnzros4lK+8goybmRwTQIvI
         mynFWmFDOLC8jzXUO+btkzzhFP/ch0REUPp7DjeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0196/1039] media: venus: core: Fix a potential NULL pointer dereference in an error handling path
Date:   Mon, 24 Jan 2022 19:33:05 +0100
Message-Id: <20220124184131.917171588@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e4debea9be7d5db52bc6a565a4c02c3c6560d093 ]

The normal path of the function makes the assumption that
'pm_ops->core_power' may be NULL.
We should make the same assumption in the error handling path or a NULL
pointer dereference may occur.

Add the missing test before calling 'pm_ops->core_power'

Fixes: 9e8efdb57879 ("media: venus: core: vote for video-mem path")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index f5fa81896012d..fd32385485fa6 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -473,7 +473,8 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 err_video_path:
 	icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
 err_cpucfg_path:
-	pm_ops->core_power(core, POWER_ON);
+	if (pm_ops->core_power)
+		pm_ops->core_power(core, POWER_ON);
 
 	return ret;
 }
-- 
2.34.1



