Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2D6BB34F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjCOMn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjCOMnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4491594F71
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FD8B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA07C433D2;
        Wed, 15 Mar 2023 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884107;
        bh=CBKuUt7ee39XOBhPZAz+aBCn5t2eTdY7hKuqXcrQxmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGcHPVkRLGMfD9OKjfFl2MLmyzfcZZeGO1avy8hA3sa6wT0kqdcVdwbeGnycDQYO+
         PGOQeC2D955SyIof9zPhD0GDJ6WblW59VSSHEDYasJM+d2BnRYA1y3gYX1CnUdIwO7
         iJ524K0gT2MqYvwKxiXZucOSaZXgM+Pokwmln248=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Koenig <chriatian.koenig@amd.com>,
        Shashank Sharma <shashank.sharma@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 110/141] drm/amdgpu: fix return value check in kfd
Date:   Wed, 15 Mar 2023 13:13:33 +0100
Message-Id: <20230315115743.345334325@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shashank Sharma <shashank.sharma@amd.com>

[ Upstream commit 20534dbcc7b7bfb447279cdcfb0d88ee3b779a18 ]

This patch fixes a return value check in kfd doorbell handling.
This function should return 0(error) only when the ida_simple_get
returns < 0(error), return > 0 is a success case.

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: 16f0013157bf ("drm/amdkfd: Allocate doorbells only when needed")
Acked-by: Christian Koenig <chriatian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index cd4e61bf04939..3ac599f74fea8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -280,7 +280,7 @@ phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 	if (!pdd->doorbell_index) {
 		int r = kfd_alloc_process_doorbells(pdd->dev,
 						    &pdd->doorbell_index);
-		if (r)
+		if (r < 0)
 			return 0;
 	}
 
-- 
2.39.2



