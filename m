Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3152473AD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390112AbgHQS71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbgHQPsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99292245C;
        Mon, 17 Aug 2020 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679316;
        bh=rSL6QdtU0Mf1/15eO1cQ6g+ILy1aHSvw5VXPrBmWID8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J1CzDKNIYrChd4QZKHFEf1sJt9aZW8RQLQKuGOgyGEHFsXSGxIOw0cj1T4WOiShq
         XdnFpb3ecsfRgkz0lgNrsjMvXVf6N1mtDnqK6+p3tjV6XUevzBrSzbEziNd/zHBRe5
         YOrKiz9SGE3FiLNZdScmWWgIHiGvTZ1mC1SHokQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 170/393] drm/amdgpu: ensure 0 is returned for success in jpeg_v2_5_wait_for_idle
Date:   Mon, 17 Aug 2020 17:13:40 +0200
Message-Id: <20200817143827.868383785@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 57f01856645afe4c3d0f9915ee2bb043e8dd7982 ]

In the cases where adev->jpeg.num_jpeg_inst is zero or the condition
adev->jpeg.harvest_config & (1 << i) is always non-zero the variable
ret is never set to an error condition and the function returns
an uninitialized value in ret.  Since the only exit condition at
the end if the function is a success then explicitly return
0 rather than a potentially uninitialized value in ret.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 14f43e8f88c5 ("drm/amdgpu: move JPEG2.5 out from VCN2.5")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index c04c2078a7c1f..a7fcb55babb85 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -462,7 +462,7 @@ static int jpeg_v2_5_wait_for_idle(void *handle)
 			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int jpeg_v2_5_set_clockgating_state(void *handle,
-- 
2.25.1



