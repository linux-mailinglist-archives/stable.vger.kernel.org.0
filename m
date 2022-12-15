Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E154264E067
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLOSNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLOSMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:12:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA99396F4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CCE461EA0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCB5C433D2;
        Thu, 15 Dec 2022 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127962;
        bh=pyepUv49aHr5CnGlPCA68LWtVIZxRoRXDWdIBzwsVOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzTRpY7FSGD/8SVroRCkO+Nxb8YgstAUfn+z5hrGCWXf5Q+4gmlRxFDkKOozEDPx5
         tubvntwSzi2SstoUZ1bZvcx2VC6YejBUvI9WigWz/yfUghc1Z02ODq5RFYgbER98DE
         8D4VkAy7k/N3V+5lL9CZ0YEEk9j+ChK8f7OGj3YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lei Rao <lei.rao@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/14] nvme-pci: clear the prp2 field when not used
Date:   Thu, 15 Dec 2022 19:10:50 +0100
Message-Id: <20221215172907.335634098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
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



