Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6295B489278
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiAJHn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241989AbiAJHkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:40:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6237C0251BD;
        Sun,  9 Jan 2022 23:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75A5F60B63;
        Mon, 10 Jan 2022 07:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1DBC36AE9;
        Mon, 10 Jan 2022 07:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800031;
        bh=miwMnJgVOnR+9E9/tWDy+mlTU5eoEgWYT3bcqx54edA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMObtAg1IjmerI1bPycudQJIwTFHLH9aY0on+dc4OBKX6uLmaqNVwEvA5SKI+el7A
         NZI+ELaW369UhSgWecq161e70oYH9kpgj1RsEak54xF2Fw++6CbXnqgtv7MBE/Uigt
         S9N0Rr12sGPHG9+AbaDvD8V09Xwe/jEvLAUbnWl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/72] drm/amd/pm: Fix xgmi link control on aldebaran
Date:   Mon, 10 Jan 2022 08:23:32 +0100
Message-Id: <20220110071823.419565546@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 19e66d512e4182a0461530fa3159638e0f55d97e ]

Fix the message argument.
	0: Allow power down
	1: Disallow power down

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 5019903db492a..c9cfeb094750d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1619,7 +1619,7 @@ static int aldebaran_allow_xgmi_power_down(struct smu_context *smu, bool en)
 {
 	return smu_cmn_send_smc_msg_with_param(smu,
 					       SMU_MSG_GmiPwrDnControl,
-					       en ? 1 : 0,
+					       en ? 0 : 1,
 					       NULL);
 }
 
-- 
2.34.1



