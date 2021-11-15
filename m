Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250BC4510D5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242799AbhKOSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243200AbhKOSxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEEE632A7;
        Mon, 15 Nov 2021 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999822;
        bh=uw+xNSlOKHQ7WjXoIaAkfruCcTcF5AlDPV/ZZq3PUAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5Lmvyko8DKn0ax1JJDjMSPE27PFCt6cY6axHU1xPb1JhWsYXq9djGblD1uyrwvKA
         0yDPC8LPeQdJWvq06+nM3lmVEgVl/HcstozibWRw7+ql7z08iG6Oo+315VUmmBrj9W
         1tdyFRpU2iIhN/hnguM3kXAGwqDD/L0qri1A+kLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 437/849] drm/msm: fix potential NULL dereference in cleanup
Date:   Mon, 15 Nov 2021 17:58:40 +0100
Message-Id: <20211115165435.067246096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 027d052a36e56789a2134772bacb4fd0860f03a3 ]

The "msm_obj->node" list needs to be initialized earlier so that the
list_del() in msm_gem_free_object() doesn't experience a NULL pointer
dereference.

Fixes: 6ed0897cd800 ("drm/msm: Fix debugfs deadlock")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211013081133.GF6010@kili
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 1e8a971a86f29..1ba18f53dbda1 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1184,6 +1184,7 @@ static int msm_gem_new_impl(struct drm_device *dev,
 	msm_obj->madv = MSM_MADV_WILLNEED;
 
 	INIT_LIST_HEAD(&msm_obj->submit_entry);
+	INIT_LIST_HEAD(&msm_obj->node);
 	INIT_LIST_HEAD(&msm_obj->vmas);
 
 	*obj = &msm_obj->base;
-- 
2.33.0



