Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3024D499A7B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573111AbiAXVo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47052 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454982AbiAXVeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC08DB8123D;
        Mon, 24 Jan 2022 21:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC18AC340E4;
        Mon, 24 Jan 2022 21:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060050;
        bh=zDHN0pvH5VbPZU6z9GYhPXlHtcv0MaHvgRH814qRAaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqdRlHxtnuHtzvuK5LNvObnS9JU9UAw0zG4gjRz+V+udDzzXaW/sylwHwkKeuXBfK
         spGGOjseoLlEDZvyPBI+K9ADqnzfQ/LifdRUofFCCt7StR1qlNxjcChFNfDQJkBkFl
         FGgviaIH+zy/7FJczD3+MX5YoxqHVvHcqFVw/y1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0822/1039] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Mon, 24 Jan 2022 19:43:31 +0100
Message-Id: <20220124184152.928542031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]

As the possible failure of the allocation, kmemdup() may return NULL
pointer.
Therefore, it should be better to check the 'props2' in order to prevent
the dereference of NULL pointer.

Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index cfedfb1e8596c..c33d689f29e8e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1060,6 +1060,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
 			return -ENODEV;
 		/* same everything but the other direction */
 		props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
+		if (!props2)
+			return -ENOMEM;
+
 		props2->node_from = id_to;
 		props2->node_to = id_from;
 		props2->kobj = NULL;
-- 
2.34.1



