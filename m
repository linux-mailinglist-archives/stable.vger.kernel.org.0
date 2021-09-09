Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C303405535
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhIINIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357661AbhIINDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2E863290;
        Thu,  9 Sep 2021 11:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188781;
        bh=bE1/ceCmSk5TxgkKSMKH0vSutzfDglqzezrJJU+M4jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLBbt24tehudwv2g3cNHAjIJQJKPPbUME4tMSpRcnRv5FqsL3OGY0HszqnXobXZ+u
         ir3hsbYy2P6O+D+XSQuiV8XEmjHiO2k95LPNOus40LGr+vQKHspG6gOUfhcRv3pkx8
         dE3SF/jJ23zh99kVfnxfae1EbIi0z0aCSdQW4+NQ6QMb0JE16ephjGY32ls0XkIgFN
         NNVFvMnbtO3F05PYlno5UB0VR483xhPkxonIWcB4Q7f8OwfTLxPSeeYSYk18eDNwqC
         lKmGmVKxRhKn+eL4qCHMCeoeHAQ2YRJqFV9TvaJzIWlpDMCouEz4eH06bd1zHiPrV3
         zR2MKpCp/gDcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/59] media: v4l2-dv-timings.c: fix wrong condition in two for-loops
Date:   Thu,  9 Sep 2021 07:58:33 -0400
Message-Id: <20210909115900.149795-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 5c8c49d240d1..bed6b7db43f5 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -207,7 +207,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	if (!v4l2_valid_dv_timings(t, cap, fnc, fnc_handle))
 		return false;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
@@ -229,7 +229,7 @@ bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic)
 {
 	unsigned int i;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		const struct v4l2_bt_timings *bt =
 			&v4l2_dv_timings_presets[i].bt;
 
-- 
2.30.2

