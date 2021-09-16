Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7AE40E895
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356055AbhIPRpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355511AbhIPRlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E54061A8E;
        Thu, 16 Sep 2021 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811200;
        bh=87pu3Ons6jzMKHdkn5aVk3uO+Yx5l5FyKqc+K/7kp34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKZn0UV2RTOJy+IApNRvtKsOj47aTCOhCP4P2+t/jtKjy1E0yzXqe2vkTk0rDFXXr
         9l4ZkGT+RckM0t+3B/Udp416dvbbRy4kThxFoPKwZK2rNxxNvOOJceH34GbnGcvye4
         KE/ACvCp8P1/hr+9N4Xa4k2pk0S/LHgEzUfStm8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.14 420/432] drm/amdgpu: Fix BUG_ON assert
Date:   Thu, 16 Sep 2021 18:02:49 +0200
Message-Id: <20210916155825.061604859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
@@ -196,7 +196,7 @@ void amdgpu_bo_placement_from_domain(str
 		c++;
 	}
 
-	BUG_ON(c >= AMDGPU_BO_MAX_PLACEMENTS);
+	BUG_ON(c > AMDGPU_BO_MAX_PLACEMENTS);
 
 	placement->num_placement = c;
 	placement->placement = places;


