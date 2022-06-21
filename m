Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33609553C82
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355743AbiFUVBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355231AbiFUU5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6192232059;
        Tue, 21 Jun 2022 13:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4861F618C2;
        Tue, 21 Jun 2022 20:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE98C3411C;
        Tue, 21 Jun 2022 20:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844655;
        bh=xgy/yEXvcMh2r2fyvGlviOnY/dveL3HAV6Wo8r2f3BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyMkhRrO4gfzYlyaa14bHL3IDxL4X6eYmhsmpeq5OT43+DJCkWWNG56QnasFxA/VJ
         4yFLArIYvyEjgoRvypFrVrCC0BTFRx2p1iPN0rY+bdRq/Y6mS0JLiauek+zZkXupwF
         uk6WS7iP68mhYyt1NLbozcjQa0KEOfGAsYZfquDkpgE38b8JH4uI4C2GFRbthB8fvG
         AtvXbCAWaLQM64SAbSEN7vq+A77DTx4uaa6tNlsRpuihobEjBF6pCW0tmfEEUZ9AM7
         SvNJO7gQMoAYuQxvAc3aVvnaQ+ydZHdfKNr2c+3/OVCYCFtUKGmGeuZkqt596Iiamf
         cuF40CPWE26kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 09/17] nvme-pci: sk hynix p31 has bogus namespace ids
Date:   Tue, 21 Jun 2022 16:50:32 -0400
Message-Id: <20220621205041.250426-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c4f01a776b28378f4f61b53f8cb0e358f4fa3721 ]

Add the quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216049
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f06bc7596e2b..78e382651198 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3359,6 +3359,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
-- 
2.35.1

