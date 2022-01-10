Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517644892CE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbiAJHvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiAJHlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12659C03327B;
        Sun,  9 Jan 2022 23:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E1760BA2;
        Mon, 10 Jan 2022 07:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F548C36AED;
        Mon, 10 Jan 2022 07:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800089;
        bh=/fvrGJS9mrvvCg2b3RyZrTxkGZGBKhvnZLQiQQLaMqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrjZO+Ax1m+H+1yAEt3jWsRWVf3M4002vQwXf99WsaYPFDRYosl6UghIKLPDJbb96
         tbYhauY8BkhbdlVJju9AXGA0FjSNeePR/fdJT9LJpmmoWD/MLGHNUM7Lc0TAXVzc5K
         rKk4bc4s7rFBN4HoX/z2Wy6invJaNVlfG4sB8rlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.15 33/72] EDAC/i10nm: Release mdev/mbase when failing to detect HBM
Date:   Mon, 10 Jan 2022 08:23:10 +0100
Message-Id: <20220110071822.674979135@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit c370baa328022cbd46c59c821d1b467a97f047be upstream.

On systems without HBM (High Bandwidth Memory) mdev/mbase are not
released/unmapped.

Add the code to release mdev/mbase when failing to detect HBM.

[Tony: re-word commit message]

Cc: <stable@vger.kernel.org>
Fixes: c945088384d0 ("EDAC/i10nm: Add support for high bandwidth memory")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20211224091126.1246-1-qiuxu.zhuo@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/i10nm_base.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -358,6 +358,9 @@ static int i10nm_get_hbm_munits(void)
 
 			mbase = ioremap(base + off, I10NM_HBM_IMC_MMIO_SIZE);
 			if (!mbase) {
+				pci_dev_put(d->imc[lmc].mdev);
+				d->imc[lmc].mdev = NULL;
+
 				i10nm_printk(KERN_ERR, "Failed to ioremap for hbm mc 0x%llx\n",
 					     base + off);
 				return -ENOMEM;
@@ -368,6 +371,12 @@ static int i10nm_get_hbm_munits(void)
 
 			mcmtr = I10NM_GET_MCMTR(&d->imc[lmc], 0);
 			if (!I10NM_IS_HBM_IMC(mcmtr)) {
+				iounmap(d->imc[lmc].mbase);
+				d->imc[lmc].mbase = NULL;
+				d->imc[lmc].hbm_mc = false;
+				pci_dev_put(d->imc[lmc].mdev);
+				d->imc[lmc].mdev = NULL;
+
 				i10nm_printk(KERN_ERR, "This isn't an hbm mc!\n");
 				return -ENODEV;
 			}


