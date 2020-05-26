Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E3B1E2D5E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391812AbgEZTI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391810AbgEZTI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15201208B3;
        Tue, 26 May 2020 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520136;
        bh=TM6WfI2yS/1xAWydxy53ecVXQ4vOqACzs3+JD/B8Y5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMxOWwhRqywDFQ+ypGd6uMndNMiFKkwCFusD+CWNv27ImDbO0apPx0dCnli0qN8UG
         irshvHCDeaRRihwP6Ojhi1sigpjjlJn06WQnNrPMQmNy+263dCnyu40xC+895ZVccL
         SwF/KpRUBnDKNzI6GHaoGyDpH1xdDTxWuhcY1/RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 5.4 070/111] drm/etnaviv: Fix a leak in submit_pin_objects()
Date:   Tue, 26 May 2020 20:53:28 +0200
Message-Id: <20200526183939.489143423@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ad99cb5e783bb03d512092db3387ead9504aad3d upstream.

If the mapping address is wrong then we have to release the reference to
it before returning -EINVAL.

Fixes: 088880ddc0b2 ("drm/etnaviv: implement softpin")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -240,8 +240,10 @@ static int submit_pin_objects(struct etn
 		}
 
 		if ((submit->flags & ETNA_SUBMIT_SOFTPIN) &&
-		     submit->bos[i].va != mapping->iova)
+		     submit->bos[i].va != mapping->iova) {
+			etnaviv_gem_mapping_unreference(mapping);
 			return -EINVAL;
+		}
 
 		atomic_inc(&etnaviv_obj->gpu_active);
 


