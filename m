Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6C129B759
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799539AbgJ0PcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799531AbgJ0Pb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD5A20728;
        Tue, 27 Oct 2020 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812718;
        bh=xnSXTGQeoqiqcMyGRm/u/OjKp+OcsyruOhk6ahlVGgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07fqauwMokOrCr+d+wRiNEF0rewnI6puiucuabQaIxgmMrdda6oMi/ZONIbHXsb97
         WYn4ZTwtVbh7bLJbInStT7/OFlwaW8G1A951BOikK149ubk5eolr97GIJDXMhjRGxU
         60FrhEMBtrMFBIleLWC0BbU+CELcHJPGDftc9fAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 305/757] dmaengine: dmatest: Check list for emptiness before access its last entry
Date:   Tue, 27 Oct 2020 14:49:15 +0100
Message-Id: <20201027135504.869250668@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b28de385b71abf31ce68ec0387638bee26ae9024 ]

After writing a garbage to the channel we get an Oops in dmatest_chan_set()
due to access to last entry in the empty list.

[  212.670672] BUG: unable to handle page fault for address: fffffff000000020
[  212.677562] #PF: supervisor read access in kernel mode
[  212.682702] #PF: error_code(0x0000) - not-present page
...
[  212.710074] RIP: 0010:dmatest_chan_set+0x149/0x2d0 [dmatest]
[  212.715739] Code: e8 cc f9 ff ff 48 8b 1d 0d 55 00 00 48 83 7b 10 00 0f 84 63 01 00 00 48 c7 c7 d0 65 4d c0 e8 ee 4a f5 e1 48 89 c6 48 8b 43 10 <48> 8b 40 20 48 8b 78 58 48 85 ff 0f 84 f5 00 00 00 e8 b1 41 f5 e1

Fix this by checking list for emptiness before accessing its last entry.

Fixes: d53513d5dc28 ("dmaengine: dmatest: Add support for multi channel testing")
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200922115847.30100-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a819611b8892c..146c3f39f576b 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -1249,15 +1249,14 @@ static int dmatest_chan_set(const char *val, const struct kernel_param *kp)
 	add_threaded_test(info);
 
 	/* Check if channel was added successfully */
-	dtc = list_last_entry(&info->channels, struct dmatest_chan, node);
-
-	if (dtc->chan) {
+	if (!list_empty(&info->channels)) {
 		/*
 		 * if new channel was not successfully added, revert the
 		 * "test_channel" string to the name of the last successfully
 		 * added channel. exception for when users issues empty string
 		 * to channel parameter.
 		 */
+		dtc = list_last_entry(&info->channels, struct dmatest_chan, node);
 		if ((strcmp(dma_chan_name(dtc->chan), strim(test_channel)) != 0)
 		    && (strcmp("", strim(test_channel)) != 0)) {
 			ret = -EINVAL;
-- 
2.25.1



