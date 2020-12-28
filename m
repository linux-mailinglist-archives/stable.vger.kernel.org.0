Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0752E3DAD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391856AbgL1OSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501994AbgL1OSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75551221F0;
        Mon, 28 Dec 2020 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165080;
        bh=CskcqQqMF6ViCEiw1r+UT6Ii0uBwWycuPsB2aTMK1Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZ11/2cMDYc7QWMTqwDbWUl0ChnqbgJ0VqMWYYMrdSkFdYFBlmjhFwOsB+DwzgqUU
         T5gSIA25e5zrdLVLx0LC+xeeeB33BTMvWHTL7zjlKBcadz2ZStsq5EMrjDgi68naaA
         gX0O38UQ7kuN8a5eLOcwaq1pDyCDHFmpDlf9AkfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        YueHaibing <yuehaibing@huawei.com>, Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/717] remoteproc: k3-dsp: Fix return value check in k3_dsp_rproc_of_get_memories()
Date:   Mon, 28 Dec 2020 13:46:41 +0100
Message-Id: <20201228125040.297684913@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6dfdf6e4e7096fead7755d47d91d72e896bb4804 ]

In case of error, the function devm_ioremap_wc() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should be
replaced with NULL test.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: 6edbe024ba17 ("remoteproc: k3-dsp: Add a remoteproc driver of K3 C66x DSPs")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20200905122503.17352-1-yuehaibing@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_dsp_remoteproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_dsp_remoteproc.c b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
index 9011e477290ce..863c0214e0a8e 100644
--- a/drivers/remoteproc/ti_k3_dsp_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
@@ -445,10 +445,10 @@ static int k3_dsp_rproc_of_get_memories(struct platform_device *pdev,
 
 		kproc->mem[i].cpu_addr = devm_ioremap_wc(dev, res->start,
 							 resource_size(res));
-		if (IS_ERR(kproc->mem[i].cpu_addr)) {
+		if (!kproc->mem[i].cpu_addr) {
 			dev_err(dev, "failed to map %s memory\n",
 				data->mems[i].name);
-			return PTR_ERR(kproc->mem[i].cpu_addr);
+			return -ENOMEM;
 		}
 		kproc->mem[i].bus_addr = res->start;
 		kproc->mem[i].dev_addr = data->mems[i].dev_addr;
-- 
2.27.0



