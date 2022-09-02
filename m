Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35465AB096
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiIBMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiIBMyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061496345;
        Fri,  2 Sep 2022 05:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D36456217E;
        Fri,  2 Sep 2022 12:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92E5C433C1;
        Fri,  2 Sep 2022 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122303;
        bh=3NtiLngTKqFl9XPjbLhNrrjCOUogu4M6f4ka2ODAOf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2LCRsZrKiE3YK7BAoziZl1wWAcyybOmoRbZvwO1DRf3kQlZ7QGDa+ETUkzk5P6NU
         cX260EqnlSTV4OWJe4ocWoYnOtrBnet8K7QdsiUZmDQyhtCnJ+04+IbphP3xC6OOe5
         C5wtdTOQfLWEsM1W5XkDZtymADf73TRtpmHUhoZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mukul Joshi <mukul.joshi@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 61/72] drm/amdgpu: Fix interrupt handling on ih_soft ring
Date:   Fri,  2 Sep 2022 14:19:37 +0200
Message-Id: <20220902121406.786915743@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit de8341ee3ce7316883e836a2c4e9bf01ab651e0f ]

There are no backing hardware registers for ih_soft ring.
As a result, don't try to access hardware registers for read
and write pointers when processing interrupts on the IH soft
ring.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c | 7 ++++++-
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c | 7 ++++++-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c | 7 ++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
index 4b5396d3e60f6..eec13cb5bf758 100644
--- a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
@@ -409,9 +409,11 @@ static u32 navi10_ih_get_wptr(struct amdgpu_device *adev,
 	u32 wptr, tmp;
 	struct amdgpu_ih_regs *ih_regs;
 
-	if (ih == &adev->irq.ih) {
+	if (ih == &adev->irq.ih || ih == &adev->irq.ih_soft) {
 		/* Only ring0 supports writeback. On other rings fall back
 		 * to register-based code with overflow checking below.
+		 * ih_soft ring doesn't have any backing hardware registers,
+		 * update wptr and return.
 		 */
 		wptr = le32_to_cpu(*ih->wptr_cpu);
 
@@ -483,6 +485,9 @@ static void navi10_ih_set_rptr(struct amdgpu_device *adev,
 {
 	struct amdgpu_ih_regs *ih_regs;
 
+	if (ih == &adev->irq.ih_soft)
+		return;
+
 	if (ih->use_doorbell) {
 		/* XXX check if swapping is necessary on BE */
 		*ih->rptr_cpu = ih->rptr;
diff --git a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
index cdd599a081258..03b7066471f9a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -334,9 +334,11 @@ static u32 vega10_ih_get_wptr(struct amdgpu_device *adev,
 	u32 wptr, tmp;
 	struct amdgpu_ih_regs *ih_regs;
 
-	if (ih == &adev->irq.ih) {
+	if (ih == &adev->irq.ih || ih == &adev->irq.ih_soft) {
 		/* Only ring0 supports writeback. On other rings fall back
 		 * to register-based code with overflow checking below.
+		 * ih_soft ring doesn't have any backing hardware registers,
+		 * update wptr and return.
 		 */
 		wptr = le32_to_cpu(*ih->wptr_cpu);
 
@@ -409,6 +411,9 @@ static void vega10_ih_set_rptr(struct amdgpu_device *adev,
 {
 	struct amdgpu_ih_regs *ih_regs;
 
+	if (ih == &adev->irq.ih_soft)
+		return;
+
 	if (ih->use_doorbell) {
 		/* XXX check if swapping is necessary on BE */
 		*ih->rptr_cpu = ih->rptr;
diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 3b4eb8285943c..2022ffbb8dba5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -385,9 +385,11 @@ static u32 vega20_ih_get_wptr(struct amdgpu_device *adev,
 	u32 wptr, tmp;
 	struct amdgpu_ih_regs *ih_regs;
 
-	if (ih == &adev->irq.ih) {
+	if (ih == &adev->irq.ih || ih == &adev->irq.ih_soft) {
 		/* Only ring0 supports writeback. On other rings fall back
 		 * to register-based code with overflow checking below.
+		 * ih_soft ring doesn't have any backing hardware registers,
+		 * update wptr and return.
 		 */
 		wptr = le32_to_cpu(*ih->wptr_cpu);
 
@@ -461,6 +463,9 @@ static void vega20_ih_set_rptr(struct amdgpu_device *adev,
 {
 	struct amdgpu_ih_regs *ih_regs;
 
+	if (ih == &adev->irq.ih_soft)
+		return;
+
 	if (ih->use_doorbell) {
 		/* XXX check if swapping is necessary on BE */
 		*ih->rptr_cpu = ih->rptr;
-- 
2.35.1



