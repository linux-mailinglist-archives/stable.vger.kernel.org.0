Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A987F5BEB36
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiITQj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiITQj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3562C1EED3
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB7E8B82A83
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 16:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7E8C433D6;
        Tue, 20 Sep 2022 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663691994;
        bh=hHaxilSANSmZ324sMSVvaV2VFRNP8bNWki66wK9Zh8s=;
        h=Subject:To:Cc:From:Date:From;
        b=uM5I9eBXm79OpkOTxiiagmCtdEr33+5RKYJpwWOfEN8YEpTkw/QYVz0vvwzRV+DzF
         nXG5TSI2gVNlPzPCJDVceP5J84RO1Qrib8E5CAUpcUu4S25BpT4hj1yfvcXRUmDtco
         jUVeKpiEZGxkfLoBAuE7k5MGfNuVwthL1CiyeZqA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: move nbio ih_doorbell_range() into ih code for" failed to apply to 5.10-stable tree
To:     alexander.deucher@amd.com, christian.koenig@amd.com,
        lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Sep 2022 18:39:52 +0200
Message-ID: <1663691992107127@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

dc1d85cb790f ("drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega")
b672cb1eee59 ("drm/amdgpu: enable retry fault wptr overflow")
bebd4c79a4eb ("drm/amdgpu: create vega20 ih blocks")
554bdbf6de74 ("drm/amdgpu: use cached ih rb control reg offsets for vega10")
21822b6a968d ("drm/amdgpu: switch to ih_enable_ring for vega10")
fd95e1b1049e ("drm/amdgpu: switch to ih_toggle_interrupts for vega10")
c73750322aaf ("drm/amdgpu: add helper to toggle ih ring interrupts for vega10")
ffa02126e0ef ("drm/amdgpu: add helper to enable an ih ring for vega10")
1ebb4841f064 ("drm/amdgpu: add helper to init ih ring regs for vega10")
4750918978a7 ("drm/amdgpu: enabled software IH ring for Vega")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dc1d85cb790f2091eea074cee24a704b2d6c4a06 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Fri, 9 Sep 2022 11:47:20 -0400
Subject: [PATCH] drm/amdgpu: move nbio ih_doorbell_range() into ih code for
 vega
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This mirrors what we do for other asics and this way we are
sure the ih doorbell range is properly initialized.

There is a comment about the way doorbells on gfx9 work that
requires that they are initialized for other IPs before GFX
is initialized.  In this case IH is initialized before GFX,
so there should be no issue.

This is a prerequisite for fixing the Unsupported Request error
reported through AER during driver load.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216373

The error was unnoticed before and got visible because of the commit
referenced below. This doesn't fix anything in the commit below, rather
fixes the issue in amdgpu exposed by the commit. The reference is only
to associate this commit with below one so that both go together.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index fde6154f2009..7324e304288e 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1224,9 +1224,6 @@ static void soc15_doorbell_range_init(struct amdgpu_device *adev)
 				ring->use_doorbell, ring->doorbell_index,
 				adev->doorbell_index.sdma_doorbell_range);
 		}
-
-		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
-						adev->irq.ih.doorbell_index);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
index 03b7066471f9..1e83db0c5438 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -289,6 +289,10 @@ static int vega10_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 2022ffbb8dba..59dfca093155 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -340,6 +340,10 @@ static int vega20_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */

