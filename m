Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8CB395E38
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhEaNzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhEaNxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4C976191A;
        Mon, 31 May 2021 13:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468003;
        bh=Ps76DS1T4sFPdqYytBA5U7j/Qf19R72Ajv+0LVHvBgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S71ILp88M2sTxRwNO/Ralk7ltsV9dkyFLmLxzRwxQNE4Rg8gqOw4ZTW2ucXstdpiT
         cAumjoxu37pntkei9oph7PFjPcyCvGqNtJ9EGJ/yj/TpSvKJT1woAs1FO4KLM3wOpy
         bdVWuT9XQUMaIwpXf8h+95XRukE//qCcNEpbeIGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 045/252] drm/amdgpu/vcn2.5: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:11:50 +0200
Message-Id: <20210531130659.518130266@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

commit 2fb536ea42d557f39f70c755f68e1aa1ad466c55 upstream.

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -321,6 +321,8 @@ static int vcn_v2_5_hw_fini(void *handle
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;


