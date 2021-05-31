Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24252395FDF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhEaOQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233664AbhEaOO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:14:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7100961999;
        Mon, 31 May 2021 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468551;
        bh=3N0ezVeZkrEOInXsqK+PFhmFlFUqU5U/DaZLgbTEMLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u30/iWSrSiCfHggXhNmboHutJUWzhL1VPR87hHnaqtD8pISjj+D35brzMJue1nKTU
         wxzjZkzdmXmlpd633C3G/32ilENTpyDhiAgAN4ujLVqSkUOo49Cum3zHt68MJOsOi6
         jxrqRl6uU3OQoJDUV0gc0ikDEHcfsjkc5cx8z7sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 033/177] drm/amdgpu/vcn2.5: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:13:10 +0200
Message-Id: <20210531130649.068609990@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -302,6 +302,8 @@ static int vcn_v2_5_hw_fini(void *handle
 	struct amdgpu_ring *ring;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;


