Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1AF2B65E6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgKQN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730692AbgKQNSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A50206D5;
        Tue, 17 Nov 2020 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619114;
        bh=VA+y975yS8kWIx+XMVvfAypuGIsmBZ4s9vz4ij4d3dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpJPkb67SN7d920AfDd+sYBgEUMqn8n7k+eI2jIkbU5k5a9nUGMbPEQSlKV3sJxgP
         BeYenAxbpdaEl4x/6tVyND6EhpioMs6nvCU1NHS5CP6anIPd4h2kEuy+1neMTr7cAi
         RJiRi+Wtu+AZIAoNl2roaJcmXrRFjW2MWNPQYlys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/101] gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
Date:   Tue, 17 Nov 2020 14:04:59 +0100
Message-Id: <20201117122114.653211832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c94c4ac1ae78b..1686a40099f21 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -739,9 +739,9 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
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



