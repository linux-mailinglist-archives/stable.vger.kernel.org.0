Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FD94512DE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347526AbhKOTkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245142AbhKOTTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8137E61AE2;
        Mon, 15 Nov 2021 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000951;
        bh=+vQac5DWKi1pa05+IgBHfABNq7vmxx5daGIOovDSs7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1GB2ThKNDG1+sXfj4CWO5lLaI3H8tXTmmJbziFs379MfS/JtIVH4O9w3LPbQaFMB
         6gb9d0remQ8hoJOtoKV+S4e2lnUwtuIcdqqDLUtB3loPWM7PEV7iydYqAbHEd9Vzq5
         8ktaYlrRwbOMt52Nio48gxWztmlUfrhxYitKdn6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.14 822/849] remoteproc: elf_loader: Fix loading segment when is_iomem true
Date:   Mon, 15 Nov 2021 18:05:05 +0100
Message-Id: <20211115165448.045438510@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


