Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44AC451DD0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347212AbhKPAeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343908AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3DD635FC;
        Mon, 15 Nov 2021 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002105;
        bh=6d+HztCoVDCFI/Ahw2vaIpDRzGSSkNZqgNNfuZ7ezJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkR1GM7bnHxy3e/NlUD9L9zZW9WjSoi2NfRIQDa+iOkTDedml/hhIp45GXVLNYcwu
         KNIgAT+u2Oa6Ye0ChOxXC6mvZvOobzfTC0cAcPa2SS8sOhrfKAwp1IfzAU2X+KeAE1
         FrdAYlcL7Ezuvqs5y+NK9gBsIWnUvBdenoar6HCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/917] drm/msm: fix potential NULL dereference in cleanup
Date:   Mon, 15 Nov 2021 17:58:55 +0100
Message-Id: <20211115165443.703293448@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 22308a1b66fc3..fd398a4eaf46e 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1132,6 +1132,7 @@ static int msm_gem_new_impl(struct drm_device *dev,
 	msm_obj->flags = flags;
 	msm_obj->madv = MSM_MADV_WILLNEED;
 
+	INIT_LIST_HEAD(&msm_obj->node);
 	INIT_LIST_HEAD(&msm_obj->vmas);
 
 	*obj = &msm_obj->base;
-- 
2.33.0



