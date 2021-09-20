Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A38A4122EE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377456AbhITSTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357928AbhITSQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816BC61A64;
        Mon, 20 Sep 2021 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158545;
        bh=EGHgnibzqYya6Ch+ZLle0Aa1249hycTtjyFaBntuLkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onNr7RapfUe1nRRSP84/el/o/arf4yE92yvQoZ4XWxS3xktIy0FgIH/sd77e/br9w
         JmcZJWNLew+HhzfpPfYUaPe40iHIuYHVEMUITeqeFrd1OTI3nZvFKTWKU+fQS0ycYn
         zhoqBS5iMSNB5ST+Zn/1jGPBhsoIS0SRX0aYV2Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.4 188/260] drm/amdgpu: Fix BUG_ON assert
Date:   Mon, 20 Sep 2021 18:43:26 +0200
Message-Id: <20210920163937.508232655@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -200,7 +200,7 @@ void amdgpu_bo_placement_from_domain(str
 		c++;
 	}
 
-	BUG_ON(c >= AMDGPU_BO_MAX_PLACEMENTS);
+	BUG_ON(c > AMDGPU_BO_MAX_PLACEMENTS);
 
 	placement->num_placement = c;
 	placement->placement = places;


