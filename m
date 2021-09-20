Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9448F4120D6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356136AbhITR6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355814AbhITR4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D3E463213;
        Mon, 20 Sep 2021 17:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158069;
        bh=OMpf2Tq8oqeZg1jpXlPCZQeyvBrPcPMumc5M0Ak/rXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4Z6KgMQeUWxSDwtmVBNtHQ3FV6z684vmmD02qKLN0pi9rNrmh7rMa67DJyPbnrgm
         SoZG2Ez3GG2YcjZdS8mW1jHRS2Q856pm2a/pkDlREHJJv50IG2FdudL8TOEWrjFEt5
         7xarBQYrb79jkS42lWc/lU2UYiXE6jw0k+CYD/gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 4.19 249/293] drm/amdgpu: Fix BUG_ON assert
Date:   Mon, 20 Sep 2021 18:43:31 +0200
Message-Id: <20210920163941.917793075@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -216,7 +216,7 @@ void amdgpu_bo_placement_from_domain(str
 		c++;
 	}
 
-	BUG_ON(c >= AMDGPU_BO_MAX_PLACEMENTS);
+	BUG_ON(c > AMDGPU_BO_MAX_PLACEMENTS);
 
 	placement->num_placement = c;
 	placement->placement = places;


