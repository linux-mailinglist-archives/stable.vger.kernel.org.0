Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001736CC55F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjC1PNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjC1PNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:13:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C966CEC77
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861A1B81D69
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECDC433EF;
        Tue, 28 Mar 2023 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016030;
        bh=dMbu8502bYiXgDXGifEtfDnNYZyIZyc8TR2o/Qxok1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZyjGEsI+kvkeKeq43hY04EsHtD2JyfRbVcdw8wirh6xg8+WWrKVpNqVrXh8qtJCS
         Hm93MJ0yVD21myalE2/OCB+G3vNU8EaiOQo0TYatwOkNQyAvSMhXV0kvgFKL3b5ae2
         ujF7v5mRKPJr+lathtIUU5Y0vXtnFw4606ZiFV3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/146] octeontx2-vf: Add missing free for alloc_percpu
Date:   Tue, 28 Mar 2023 16:42:09 +0200
Message-Id: <20230328142604.365837538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit f038f3917baf04835ba2b7bcf2a04ac93fbf8a9c ]

Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
memory leak, same as the "pf->hw.lmt_info" in
`drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.

Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Geethasowjanya Akula <gakula@marvell.com>
Link: https://lore.kernel.org/r/20230317064337.18198-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 03b4ec630432b..9822db362c88e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -704,6 +704,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_unreg_netdev:
 	unregister_netdev(netdev);
 err_detach_rsrc:
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2_detach_resources(&vf->mbox);
@@ -738,6 +739,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 		destroy_workqueue(vf->otx2_wq);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2vf_vfaf_mbox_destroy(vf);
-- 
2.39.2



