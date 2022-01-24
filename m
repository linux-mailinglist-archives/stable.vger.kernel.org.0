Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AD54998B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352548AbiAXV3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349609AbiAXVSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:18:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0DDB614B8;
        Mon, 24 Jan 2022 21:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4075C340E4;
        Mon, 24 Jan 2022 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059085;
        bh=NArxHwZeGD7GaMmhx/LlhECXgL7KMKQlYAHAYYPDj34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9rh77rzuFtCc0VgER0bo1cuClU1Y5l75TvX2G5oaWUWnxf9fTU3TfInc9WIigVMJ
         cD362BFh/A1DOIsgvDJ3MFOes02t2tCZmK9CFnCPbPB5w8ZbZiZ6baF/Id6Ah8Pvkm
         Lb8IiQt+0mvNerLPpGGCHXpm0E9NCSVgvLcUTjyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0499/1039] iommu/iova: Fix race between FQ timeout and teardown
Date:   Mon, 24 Jan 2022 19:38:08 +0100
Message-Id: <20220124184142.029731523@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit d7061627d701c90e1cac1e1e60c45292f64f3470 ]

It turns out to be possible for hotplugging out a device to reach the
stage of tearing down the device's group and default domain before the
domain's flush queue has drained naturally. At this point, it is then
possible for the timeout to expire just before the del_timer() call
in free_iova_flush_queue(), such that we then proceed to free the FQ
resources while fq_flush_timeout() is still accessing them on another
CPU. Crashes due to this have been observed in the wild while removing
NVMe devices.

Close the race window by using del_timer_sync() to safely wait for any
active timeout handler to finish before we start to free things. We
already avoid any locking in free_iova_flush_queue() since the FQ is
supposed to be inactive anyway, so the potential deadlock scenario does
not apply.

Fixes: 9a005a800ae8 ("iommu/iova: Add flush timer")
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
[ rm: rewrite commit message ]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/0a365e5b07f14b7344677ad6a9a734966a8422ce.1639753638.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iova.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 9e8bc802ac053..920fcc27c9a1e 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -83,8 +83,7 @@ static void free_iova_flush_queue(struct iova_domain *iovad)
 	if (!has_iova_flush_queue(iovad))
 		return;
 
-	if (timer_pending(&iovad->fq_timer))
-		del_timer(&iovad->fq_timer);
+	del_timer_sync(&iovad->fq_timer);
 
 	fq_destroy_all_entries(iovad);
 
-- 
2.34.1



