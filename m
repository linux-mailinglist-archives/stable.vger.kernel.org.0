Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BDE64408B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiLFJw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiLFJvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:51:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B341010E2;
        Tue,  6 Dec 2022 01:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D3B615FA;
        Tue,  6 Dec 2022 09:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA13C433B5;
        Tue,  6 Dec 2022 09:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320226;
        bh=pyepUv49aHr5CnGlPCA68LWtVIZxRoRXDWdIBzwsVOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTiMGEmQ+AOaJaqAW2iNdQXejm+7e/cfce5HAxChl46VKWBX5cUh6Cok8z/u93dGE
         tEmy7ILEmZrpGlwaV+NubWsz/97NUOyC6BW5q6sYndk7K6Cl7y2dKBvJnXWKY4hU7C
         2jXP2gzv42ZRU2lPnwO1gXKMcOBZMaXCiU7wRzJnRd5vF7txDOogMDFL5Ik262LIET
         cM3bY8euxhXBn+CdHgjEjon7vzF6kdsqJn3RrxP85Cp8OMM9Nnsjp2IK/2OplC12SY
         J4AnPXneMjYnoPliqkyxWzKj78HXS9RtbIQzWXZ0PVN8EQEZvVgRQvwSijyR6mCjul
         BJhdZTcrMjr3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lei Rao <lei.rao@intel.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 12/12] nvme-pci: clear the prp2 field when not used
Date:   Tue,  6 Dec 2022 04:49:54 -0500
Message-Id: <20221206094955.987437-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lei Rao <lei.rao@intel.com>

[ Upstream commit a56ea6147facce4ac1fc38675455f9733d96232b ]

If the prp2 field is not filled in nvme_setup_prp_simple(), the prp2
field is garbage data. According to nvme spec, the prp2 is reserved if
the data transfer does not cross a memory page boundary, so clear it to
zero if it is not used.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 772bdc6845fb..d49df7123677 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -814,6 +814,8 @@ static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
 	cmnd->dptr.prp1 = cpu_to_le64(iod->first_dma);
 	if (bv->bv_len > first_prp_len)
 		cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma + first_prp_len);
+	else
+		cmnd->dptr.prp2 = 0;
 	return BLK_STS_OK;
 }
 
-- 
2.35.1

