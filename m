Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E9512C98C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfL2SKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfL2Ro7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A70208C4;
        Sun, 29 Dec 2019 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641499;
        bh=dT2u6tnP0SjCCmVPHuAARurqhNxrvVeh29ZCBtjl+Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdwvuGzEv3zRHK8zPyogtiopdBOa5PmXKOdIo9UWLZi1jDTCE7gkEdUBBaT69C1J5
         BcQBHCWqrjZebL2psWnIRWKbtvlO+abP/xjP3OA7yfpNRsmKHcJH52/mwhRr3x4kDC
         QXingTWNpue6lgvcGeXUecmXmHk8BoRP7x5Z9wyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Cornij <nikola.cornij@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/434] drm/amd/display: Set number of pipes to 1 if the second pipe was disabled
Date:   Sun, 29 Dec 2019 18:22:23 +0100
Message-Id: <20191229172707.527745301@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 2fef0faa1cdc5d41ce3ef83f7b8f7e7ecb02d700 ]

[why]
Some ODM-related register settings are inconsistently updated by VBIOS, causing
the state in DC to be invalid, which would then end up crashing in certain
use-cases (such as disable/enable device).

[how]
Check the enabled status of the second pipe when determining the number of
OPTC sources. If the second pipe is disabled, set the number of sources to 1
regardless of other settings (that may not be updated correctly).

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index 2137e2be2140..dda90995ba93 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -287,6 +287,10 @@ void optc2_get_optc_source(struct timing_generator *optc,
 		*num_of_src_opp = 2;
 	else
 		*num_of_src_opp = 1;
+
+	/* Work around VBIOS not updating OPTC_NUM_OF_INPUT_SEGMENT */
+	if (*src_opp_id_1 == 0xf)
+		*num_of_src_opp = 1;
 }
 
 void optc2_set_dwb_source(struct timing_generator *optc,
-- 
2.20.1



