Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15FE551968
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiFTMxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241511AbiFTMxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4598CD11B;
        Mon, 20 Jun 2022 05:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB59B811A6;
        Mon, 20 Jun 2022 12:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685A8C3411B;
        Mon, 20 Jun 2022 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729584;
        bh=osKyJ1+KTbP33abJvrFOEn7PkpMGgyBTQRpahpLYjcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpBlVjuv5IZdpi9pVyLov2O70llMCEYFl6auDUe8o+pKCTrAjYxwJZZDqLD71JxZK
         WvyP45Q2cjnSro5sOE/PDM5+EIt0NLskwflppN9enz06cb7XCxP8iNTSTn2iMTbAIk
         EKMlUjmmCF/dAUqEOrODQc9HsGOtHSxq8WxyBmIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 010/141] drm/amdkfd: Use mmget_not_zero in MMU notifier
Date:   Mon, 20 Jun 2022 14:49:08 +0200
Message-Id: <20220620124729.823328758@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit fa582c6f3684ac0098a9d02ddf0ed52a02b37127 ]

MMU notifier callback may pass in mm with mm->mm_users==0 when process
is exiting, use mmget_no_zero to avoid accessing invalid mm in deferred
list work after mm is gone.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 3b8856b4cece..5979335d7afd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2286,6 +2286,8 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 
 	if (range->event == MMU_NOTIFY_RELEASE)
 		return true;
+	if (!mmget_not_zero(mni->mm))
+		return true;
 
 	start = mni->interval_tree.start;
 	last = mni->interval_tree.last;
@@ -2312,6 +2314,7 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 	}
 
 	svm_range_unlock(prange);
+	mmput(mni->mm);
 
 	return true;
 }
-- 
2.35.1



