Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD6E5C0229
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiIUPtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiIUPsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58F57C304;
        Wed, 21 Sep 2022 08:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2480C6312A;
        Wed, 21 Sep 2022 15:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B24C433C1;
        Wed, 21 Sep 2022 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775258;
        bh=iqaezEEeiDG99/bBFyg4bCNJe4txiqLmFcEDC6sXYqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSAeoSkttwf9IK8i6N/Nq6wvBR+EKIbzYhaknuzJZLnqU1sc/RmihlPdEdhPoWi8B
         WIAOn99LBPa4bj7GWFc9C9r2JGdDhbu7i7zM1X9gHuCLuZby901YXcOEXruhfNTKVs
         GuhnYJAYbAvMHS6z6eZxZS9h000lbNvJVBbNhYGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 32/38] drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega
Date:   Wed, 21 Sep 2022 17:46:16 +0200
Message-Id: <20220921153647.292908167@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit dc1d85cb790f2091eea074cee24a704b2d6c4a06 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c     |    3 ---
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c |    4 ++++
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c |    4 ++++
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1224,9 +1224,6 @@ static void soc15_doorbell_range_init(st
 				ring->use_doorbell, ring->doorbell_index,
 				adev->doorbell_index.sdma_doorbell_range);
 		}
-
-		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
-						adev->irq.ih.doorbell_index);
 	}
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -289,6 +289,10 @@ static int vega10_ih_irq_init(struct amd
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -340,6 +340,10 @@ static int vega20_ih_irq_init(struct amd
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */


