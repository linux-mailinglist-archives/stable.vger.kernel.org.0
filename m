Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8322147FE3F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhL0P1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbhL0P1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:27:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E688C06173E;
        Mon, 27 Dec 2021 07:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F41B810A3;
        Mon, 27 Dec 2021 15:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A36FC36AFC;
        Mon, 27 Dec 2021 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618849;
        bh=lxj0CGnaQWsdrpP+ym0cjNUD1Q9ZWMmAFxZGfZWd1/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZU79SCaAAErcyL3XJjB+XBBxU4dseioz5c5PvS4Lsq93aZ/IHtGX7LXjsaCirRQI
         okJI1qxDciPro2BGBrAhjz2CoFvk74dWshQcrz//RMzaBC+CXm0RqJ/p7e9JcwpCpS
         6GEnZ/tyJxCniKjVglKa4jpSDA+bzmHfLRbvrrVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "xen-devel@lists.xenproject.org, Juergen Gross" <jgross@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 12/17] xen/blkfront: fix bug in backported patch
Date:   Mon, 27 Dec 2021 16:27:07 +0100
Message-Id: <20211227151316.349920128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
References: <20211227151315.962187770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

The backport of commit 8f5a695d99000fc ("xen/blkfront: don't take local
copy of a request from the ring page") to stable 4.4 kernel introduced
a bug when adding the needed blkif_ring_get_request() function, as
info->ring.req_prod_pvt was incremented twice now.

Fix that be deleting the now superfluous increments after calling that
function.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -493,8 +493,6 @@ static int blkif_queue_discard_req(struc
 	else
 		ring_req->u.discard.flag = 0;
 
-	info->ring.req_prod_pvt++;
-
 	/* Copy the request to the ring page. */
 	*final_ring_req = *ring_req;
 	info->shadow[id].inflight = true;
@@ -711,8 +709,6 @@ static int blkif_queue_rw_req(struct req
 	if (setup.segments)
 		kunmap_atomic(setup.segments);
 
-	info->ring.req_prod_pvt++;
-
 	/* Copy request(s) to the ring page. */
 	*final_ring_req = *ring_req;
 	info->shadow[id].inflight = true;


