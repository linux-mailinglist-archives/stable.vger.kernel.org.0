Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978602ACCC0
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbgKJD44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387766AbgKJD4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C1720731;
        Tue, 10 Nov 2020 03:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980614;
        bh=fsW6bgFU3buu5xvx3D94Li6vVxUF4G38khvZ+rUjhDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlAPlBet6raD7eD0fRzFgD/cl7/YBqvZ0IEUzXG3ppHwKLqRYXMgyEAHZYd1DuTHa
         EXEflWe70gxy5q4++Md7Ln95iqGzeKF8tIAl0K5JbZ45vD7UOzdMTtlciLWjq25Xqf
         Yl5BgPSRBk5tENFTkkl7+2p4qvStUatygbdN8OW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 02/10] gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
Date:   Mon,  9 Nov 2020 22:56:43 -0500
Message-Id: <20201110035651.425177-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035651.425177-1-sashal@kernel.org>
References: <20201110035651.425177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit d0f17d3883f1e3f085d38572c2ea8edbd5150172 ]

Function gfs2_clear_rgrpd calls kfree(rgd->rd_bits) before calling
return_all_reservations, but return_all_reservations still dereferences
rgd->rd_bits in __rs_deltree.  Fix that by moving the call to kfree below the
call to return_all_reservations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2736e9cfc2ee9..99dcbdc1ff3a4 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -747,9 +747,9 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_free_clones(rgd);
+		return_all_reservations(rgd);
 		kfree(rgd->rd_bits);
 		rgd->rd_bits = NULL;
-		return_all_reservations(rgd);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
 }
-- 
2.27.0

