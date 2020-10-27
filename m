Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FA229B3B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780289AbgJ0Oyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763116AbgJ0Ooo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:44:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D550521527;
        Tue, 27 Oct 2020 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809884;
        bh=AGYOV/Hmur2XNcduLhRatyeBVAK1wfJ200zWnFeF+1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyvwhJdTqxCe1vN6AO/mnbMv2B2yn6Wc8V2RlNeLF88VZ8uFKJjUVHHaICce6yTOr
         bi4iUP0+UAraXydSqFdUHQUFIyJUjMV6tNRz6lkC+OmHV+BmU9NVU+YDcZNXY6uYPZ
         7cm22lwba1nW2xb/rnBc83bU8EpzIf5ZqUng5b0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 312/408] soc: fsl: qbman: Fix return value on success
Date:   Tue, 27 Oct 2020 14:54:10 +0100
Message-Id: <20201027135509.505152820@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 750cf40c0f7088f36a8a5d102e0488b1ac47faf5 ]

On error the function was meant to return -ERRNO.  This also fixes
compile warning:

  drivers/soc/fsl/qbman/bman.c:640:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]

Fixes: 0505d00c8dba ("soc/fsl/qbman: Cleanup buffer pools if BMan was initialized prior to bootup")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/bman.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qbman/bman.c b/drivers/soc/fsl/qbman/bman.c
index f4fb527d83018..c5dd026fe889f 100644
--- a/drivers/soc/fsl/qbman/bman.c
+++ b/drivers/soc/fsl/qbman/bman.c
@@ -660,7 +660,7 @@ int bm_shutdown_pool(u32 bpid)
 	}
 done:
 	put_affine_portal();
-	return 0;
+	return err;
 }
 
 struct gen_pool *bm_bpalloc;
-- 
2.25.1



