Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3001B3C07
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgDVKBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbgDVKBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:01:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A1020857;
        Wed, 22 Apr 2020 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549708;
        bh=UhxRCud9eERBVQJgTbhJkRu2qnYOAzM72Fx3bVmz4As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAtCtOwexHSpqjrw0tUKgvvnuXdfNWKoeC5YzGLIOCrDz/2FaKU07yktFNmmpahEm
         imgCuqnX+gYO6yWW6KvRzAfVOK4h8ew9WpCtDQl1QaqtocY457lKv1JIHpEvdGvf6W
         EOGJClEvbTWR+wDJcNi1TXg7djy/qeI09OmzwBCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Moriarty <joe.moriarty@oracle.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 075/100] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Wed, 22 Apr 2020 11:56:45 +0200
Message-Id: <20200422095036.630899224@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Moriarty <joe.moriarty@oracle.com>

commit 22a07038c0eaf4d1315a493ce66dcd255accba19 upstream.

The Parfait (version 2.1.0) static code analysis tool found the
following NULL pointer derefernce problem.

- drivers/gpu/drm/drm_dp_mst_topology.c
The call to drm_dp_calculate_rad() in function drm_dp_port_setup_pdt()
could result in a NULL pointer being returned to port->mstb due to a
failure to allocate memory for port->mstb.

Signed-off-by: Joe Moriarty <joe.moriarty@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20180212195144.98323-3-joe.moriarty@oracle.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1036,10 +1036,12 @@ static bool drm_dp_port_setup_pdt(struct
 		lct = drm_dp_calculate_rad(port, rad);
 
 		port->mstb = drm_dp_add_mst_branch_device(lct, rad);
-		port->mstb->mgr = port->mgr;
-		port->mstb->port_parent = port;
+		if (port->mstb) {
+			port->mstb->mgr = port->mgr;
+			port->mstb->port_parent = port;
 
-		send_link = true;
+			send_link = true;
+		}
 		break;
 	}
 	return send_link;


