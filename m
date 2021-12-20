Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6FC47AE02
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhLTO5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45278 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbhLTOz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B1D3611A4;
        Mon, 20 Dec 2021 14:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710C9C36AE7;
        Mon, 20 Dec 2021 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012126;
        bh=L9Tn91wuneDVfUE4F8HLWO62n9jSIodEQPJIToRT1Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLmq8d8i+tt9hCfafbAj+U7DcLn9ETHdvIKYhNOtmxbMhWN/JZKWmreeSNqWF71lT
         WuyKiq70atv+Uf0yw451fAE7geT82BOmyxSnFEaM1cfB0qj1DXboXvLeoeAGIMwxAE
         OrqOCUnQR3PbC3OOazYBjSmNp04F6s9+nErAsq8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/177] drm/amd/pm: fix a potential gpu_metrics_table memory leak
Date:   Mon, 20 Dec 2021 15:33:59 +0100
Message-Id: <20211220143043.114371484@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit aa464957f7e660abd554f2546a588f6533720e21 ]

Memory is allocated for gpu_metrics_table in renoir_init_smc_tables(),
but not freed in int smu_v12_0_fini_smc_tables(). Free it!

Fixes: 95868b85764a ("drm/amd/powerplay: add Renoir support for gpu metrics export")

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
index d60b8c5e87157..43028f2cd28b5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
@@ -191,6 +191,9 @@ int smu_v12_0_fini_smc_tables(struct smu_context *smu)
 	kfree(smu_table->watermarks_table);
 	smu_table->watermarks_table = NULL;
 
+	kfree(smu_table->gpu_metrics_table);
+	smu_table->gpu_metrics_table = NULL;
+
 	return 0;
 }
 
-- 
2.33.0



