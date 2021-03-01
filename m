Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925F2329088
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbhCAUJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhCAUAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6158964ED4;
        Mon,  1 Mar 2021 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621415;
        bh=hnFsvMwecTe40PoLz92zGKTESNgVNXQDZ6q2KUkJO0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSpfUw8A3y2t1gu7DZWix0k6UjrGZ1O/TmzEzyE4Ae5nRAScn2Nfibl0PIBYWzMDA
         IRaTHxLvkBDcdE7gMhH5YkD9j2/qOxgsSH997TZnIDDcQ1+T7ZGfpo73M7oWT9Lf8M
         5S6EO2tRKpj1uuw4gPeX92byaLdkHpvMwHxr3Fr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Velikov <emil.velikov@collabora.com>,
        Rob Clark <robdclark@chromium.org>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 508/775] drm/msm: Fix legacy relocs path
Date:   Mon,  1 Mar 2021 17:11:16 +0100
Message-Id: <20210301161226.619964755@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit c8d99bb938d3303989c4988caf090084073e85a2 ]

In moving code around, we ended up using the same pointer to
copy_from_user() the relocs tables as we used for the cmd table
entry, which is clearly not right.  This went unnoticed because
modern mesa on non-ancent kernels does not actually use relocs.
But this broke ancient mesa on modern kernels.

Reported-by: Emil Velikov <emil.velikov@collabora.com>
Fixes: 20224d715a88 ("drm/msm/submit: Move copy_from_user ahead of locking bos")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index d04c349d8112a..5480852bdedaf 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -198,6 +198,8 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 		submit->cmd[i].idx  = submit_cmd.submit_idx;
 		submit->cmd[i].nr_relocs = submit_cmd.nr_relocs;
 
+		userptr = u64_to_user_ptr(submit_cmd.relocs);
+
 		sz = array_size(submit_cmd.nr_relocs,
 				sizeof(struct drm_msm_gem_submit_reloc));
 		/* check for overflow: */
-- 
2.27.0



