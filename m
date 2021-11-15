Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE4A4514CC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbhKOUNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234173AbhKOT0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D7163700;
        Mon, 15 Nov 2021 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003320;
        bh=+vQac5DWKi1pa05+IgBHfABNq7vmxx5daGIOovDSs7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG8oHwlAPUsBwsZZRsH1SaWUUpCDMAM/TLatRxePO0PhYydFk12y/ONQFY3WreWtD
         17yQ3dSGs/KX7q13186T2F2u+oAdqEIssdSu8PnYyc2c+3A+d3zhOvi1trWjhan4aN
         5Zh500vp3Qjzre2a/hEVEafqg1u65jByTG0Jo+n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 892/917] remoteproc: elf_loader: Fix loading segment when is_iomem true
Date:   Mon, 15 Nov 2021 18:06:27 +0100
Message-Id: <20211115165459.297743041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 24acbd9dc934f5d9418a736c532d3970a272063e upstream.

It seems luckliy work on i.MX platform, but it is wrong.
Need use memcpy_toio, not memcpy_fromio.

Fixes: 40df0a91b2a5 ("remoteproc: add is_iomem to da_to_va")
Tested-by: Dong Aisheng <aisheng.dong@nxp.com> (i.MX8MQ)
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-2-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_elf_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -220,7 +220,7 @@ int rproc_elf_load_segments(struct rproc
 		/* put the segment where the remote processor expects it */
 		if (filesz) {
 			if (is_iomem)
-				memcpy_fromio(ptr, (void __iomem *)(elf_data + offset), filesz);
+				memcpy_toio((void __iomem *)ptr, elf_data + offset, filesz);
 			else
 				memcpy(ptr, elf_data + offset, filesz);
 		}


