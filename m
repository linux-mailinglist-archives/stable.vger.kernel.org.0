Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9063DF6A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiK3SrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiK3Sqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E889B78A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC90B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE655C433C1;
        Wed, 30 Nov 2022 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834004;
        bh=8Qs3HRrU/Ua8S7E6cww+VJ6H5DvIiDx8jFgTutqKWZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcENoSwe/rJXMYPulIkeI5wi2knsOfF1apVXOIbkyE0oa/ZcDjt+jrakAGNACv+Zd
         IL8ELlekfArTTJRgaHbLT7wG+0QjJ8B8Mlbi2WMo0EFE7J9dV0UxyFGp3wrwCxLVaJ
         QjzDbBaGyHgn4IDH2YMWA1mrhjXAwSQXznCwWCl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 094/289] octeontx2-af: debugsfs: fix pci device refcount leak
Date:   Wed, 30 Nov 2022 19:21:19 +0100
Message-Id: <20221130180546.274365889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d66608803aa2ffb9e475623343f69996305771ae ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put().

So before returning from rvu_dbg_rvu_pf_cgx_map_display() or
cgx_print_dmac_flt(), pci_dev_put() is called to avoid refcount
leak.

Fixes: dbc52debf95f ("octeontx2-af: Debugfs support for DMAC filters")
Fixes: e2fb37303865 ("octeontx2-af: Display CGX, NIX and PF map in debugfs.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221117124658.162409-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index f42a09f04b25..70cda1571324 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -535,6 +535,8 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 		sprintf(lmac, "LMAC%d", lmac_id);
 		seq_printf(filp, "%s\t0x%x\t\tNIX%d\t\t%s\t%s\n",
 			   dev_name(&pdev->dev), pcifunc, blkid, cgx, lmac);
+
+		pci_dev_put(pdev);
 	}
 	return 0;
 }
@@ -2221,6 +2223,7 @@ static int cgx_print_dmac_flt(struct seq_file *s, int lmac_id)
 		}
 	}
 
+	pci_dev_put(pdev);
 	return 0;
 }
 
-- 
2.35.1



