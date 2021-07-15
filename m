Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB103CAA03
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhGOTLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242835AbhGOTJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA33613F3;
        Thu, 15 Jul 2021 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375885;
        bh=Ct3Y7jkwoKYSQltROAjqMjbfy7zwRvvP9DDxZboJejs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSq7IoJhYalNf2oee/PNYD7BM4jVZzcscnBQfsOX2NVWxGNbhfBi7QNK4Dkd6jmJC
         zq1wvtIdaYZjLLSRWaoosFDxVPRS+XyqnvFIBv26shN0khnq999Ng9CzAhnJD1xNDR
         VURnWv+hrIyDwo5VP7krf4yO9LXriAh70jUihGm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feifei Xu <Feifei.Xu@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 036/266] drm/amd/pm: fix return value in aldebaran_set_mp1_state()
Date:   Thu, 15 Jul 2021 20:36:31 +0200
Message-Id: <20210715182620.679432868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feifei Xu <Feifei.Xu@amd.com>

[ Upstream commit 5051cb794ac5d92154e186d87cdc12cba613f4f6 ]

For default cases,we should return 0. Otherwise resume will
abort because of the wrong return value.

Signed-off-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index dcbe3a72da09..16ad4683eb69 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1779,10 +1779,8 @@ static int aldebaran_set_mp1_state(struct smu_context *smu,
 	case PP_MP1_STATE_UNLOAD:
 		return smu_cmn_set_mp1_state(smu, mp1_state);
 	default:
-		return -EINVAL;
+		return 0;
 	}
-
-	return 0;
 }
 
 static const struct pptable_funcs aldebaran_ppt_funcs = {
-- 
2.30.2



