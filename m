Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80F24124E5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380558AbhITSjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380745AbhITShB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD266331C;
        Mon, 20 Sep 2021 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158974;
        bh=RwUoIF/dPA6zpUyPhoKOOTLa63Acc4/1CHdFLbTNXSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQxwzKkA8hUNwYMEs3TKeaH1k1n5qKpjfas2gGHz0X1EjGazBWn11YERCnSHqPYLs
         /002qmdJ89QKYoNO97KA8OwbBMQ61BCLrmerUcrcpJAHiZWIkW9bWO2amvsGhPBkgq
         73JNehRwoa9KnqRJpYrduurzQiMR2rzayzII7nFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Jack Gui <Jack.Gui@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 019/168] drm/amd/pm: fix the issue of uploading powerplay table
Date:   Mon, 20 Sep 2021 18:42:37 +0200
Message-Id: <20210920163922.276739874@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

commit 5598d7c21a0bcab900f281dca4efbb1f80add0fe upstream.

fix the issue of uploading powerplay table due to the dependancy of rlc.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Jack Gui <Jack.Gui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1381,7 +1381,7 @@ static int smu_disable_dpms(struct smu_c
 	 */
 	if (smu->uploading_custom_pp_table &&
 	    (adev->asic_type >= CHIP_NAVI10) &&
-	    (adev->asic_type <= CHIP_DIMGREY_CAVEFISH))
+	    (adev->asic_type <= CHIP_BEIGE_GOBY))
 		return smu_disable_all_features_with_exception(smu,
 							       true,
 							       SMU_FEATURE_COUNT);


