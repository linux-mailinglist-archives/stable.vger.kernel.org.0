Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56C540541
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbiFGRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346156AbiFGRWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:22:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0E106365;
        Tue,  7 Jun 2022 10:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26FD46009B;
        Tue,  7 Jun 2022 17:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37128C385A5;
        Tue,  7 Jun 2022 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622483;
        bh=fsc6IIIk1awweZ+LPL499ZV/HHQ210t5VuqTymzmdZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsSbGpKHv9J9w+A7851IbebZsJwpVL9IwlsZmOJAYrx0kvCdu+Lq8Ce9De5ALRHqK
         Rqo/QfB2PTldUneLD9ZrGe0oz04yBsIQQ2OkGE+MJWE1plqFVZAhfLlTo5rkNSNIHh
         Mbi4FLHjtv88A5hNJFKVevM3CHMD2Kb6MZoFMIPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/452] iommu/vt-d: Add RPLS to quirk list to skip TE disabling
Date:   Tue,  7 Jun 2022 18:58:01 +0200
Message-Id: <20220607164909.265970499@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>

[ Upstream commit 0a967f5bfd9134b89681cae58deb222e20840e76 ]

The VT-d spec requires (10.4.4 Global Command Register, TE
field) that:

Hardware implementations supporting DMA draining must drain
any in-flight DMA read/write requests queued within the
Root-Complex before completing the translation enable
command and reflecting the status of the command through
the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do
so after some kind of power state transition. As the
result, the system might stuck in iommu_disable_translati
on(), waiting for the completion of TE transition.

This adds RPLS to a quirk list for those devices and skips
TE disabling if the qurik hits.

Link: https://gitlab.freedesktop.org/drm/intel/-/issues/4898
Tested-by: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220302043256.191529-1-tejaskumarx.surendrakumar.upadhyay@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 21749859ad45..477dde39823c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -6296,7 +6296,7 @@ static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a)
+	    ver != 0x9a && ver != 0xa7)
 		return;
 
 	if (risky_device(dev))
-- 
2.35.1



