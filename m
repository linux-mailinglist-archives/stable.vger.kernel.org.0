Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2F405477
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbhIIM6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356632AbhIIMze (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5955463254;
        Thu,  9 Sep 2021 11:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188694;
        bh=LnkxSRlZlGz97B1C0web42fPnux/0Hyme/3MF6rOfpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMV5NrsXGI19up0G+I9dZXjq49SFR1xKQ7Pt3tN9MXY9EqOkV2JRl9Z/MSJHLqFHn
         frtzvPSkwnv0tG/v61ltkmW08K6d6zoIs192iFu2uUo9yvU9MsExJZbFXR6bf1a8CU
         S8bcfYX2emzKm9t/RDpPjbZBUgLiv8FPRyLtewZFWElCO5sEleExbZAfZjYNOGRI8m
         LgsoDUh3uhc+nOYYtfWDfKc8k9YF+Vi70AiViwr3d8OPXYCnVlTiZSHmnXXZLayk9Z
         NfTCHQAIqi1S3gNyzz6C+d/gThk3BiHyLHFwCgyy+Ne3S7jLdqMtrv6WCE4so8J2l1
         rqnvlqEqHLKyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 38/74] media: v4l2-dv-timings.c: fix wrong condition in two for-loops
Date:   Thu,  9 Sep 2021 07:56:50 -0400
Message-Id: <20210909115726.149004-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 4108b3e6db31acc4c68133290bbcc87d4db905c9 ]

These for-loops should test against v4l2_dv_timings_presets[i].bt.width,
not if i < v4l2_dv_timings_presets[i].bt.width. Luckily nothing ever broke,
since the smallest width is still a lot higher than the total number of
presets, but it is wrong.

The last item in the presets array is all 0, so the for-loop must stop
when it reaches that sentinel.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index a24b40dfec97..af38c989ff33 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -196,7 +196,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	if (!v4l2_valid_dv_timings(t, cap, fnc, fnc_handle))
 		return false;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
@@ -218,7 +218,7 @@ bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic)
 {
 	unsigned int i;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		const struct v4l2_bt_timings *bt =
 			&v4l2_dv_timings_presets[i].bt;
 
-- 
2.30.2

