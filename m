Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB040E119
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbhIPQ1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241184AbhIPQZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4D31610D1;
        Thu, 16 Sep 2021 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808999;
        bh=KogY5S6F5QZJobUtOmE8FKHvh/DEuFLnpzoyhr91zvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laWqUb4PJfsqq/ykpvsNU4uU+/ztH4hrZnMTUw2aFZGOvcK1iukNlpFlo/4m/ub4d
         symys1eZLHc4Pr5LaVGlqyt1tEieUgd6G0Jooh2WBKVVd0DPEyBtudv8c80COJDmp6
         RFtvb9YLU41zTZZDtHSdGbz/+qmvv99LFMlobtKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 300/306] drm/amdgpu: Fix BUG_ON assert
Date:   Thu, 16 Sep 2021 18:00:45 +0200
Message-Id: <20210916155804.317306408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

commit ea7acd7c5967542353430947f3faf699e70602e5 upstream.

With added CPU domain to placement you can have
now 3 placemnts at once.

CC: stable@kernel.org
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210622162339.761651-5-andrey.grodzovsky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -207,7 +207,7 @@ void amdgpu_bo_placement_from_domain(str
 		c++;
 	}
 
-	BUG_ON(c >= AMDGPU_BO_MAX_PLACEMENTS);
+	BUG_ON(c > AMDGPU_BO_MAX_PLACEMENTS);
 
 	placement->num_placement = c;
 	placement->placement = places;


