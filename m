Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0ADF5426CB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382989AbiFHBPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843649AbiFHALR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B4C19EC08;
        Tue,  7 Jun 2022 12:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D38660C7F;
        Tue,  7 Jun 2022 19:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CCDC385A5;
        Tue,  7 Jun 2022 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629979;
        bh=WQOEOZu+GFtit9nfZ0CRil1D8zDpzePz2KgoVdWnlhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4FjkMYB7yPyJ1sdJXVrqtfU5QdNJHklbClfeA8xi6bsZBM4r7re/BX35HrrkECM6
         PA6aHoCLVfeSsFWBH2jmED4R/rkuIfo37kJKAJ4+0c1yIVOVy9dbELhFFbyko4o533
         TdBhKxQm5/LxOBKMKaHookKsHowQZbFcqCmYiKsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 5.18 857/879] vdpasim: allow to enable a vq repeatedly
Date:   Tue,  7 Jun 2022 19:06:15 +0200
Message-Id: <20220607165027.730597397@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugenio Pérez <eperezma@redhat.com>

commit 242436973831aa97e8ce19533c6c912ea8def31b upstream.

Code must be resilient to enable a queue many times.

At the moment the queue is resetting so it's definitely not the expected
behavior.

v2: set vq->ready = 0 at disable.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Cc: stable@vger.kernel.org
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20220519145919.772896-1-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -353,11 +353,14 @@ static void vdpasim_set_vq_ready(struct
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	bool old_ready;
 
 	spin_lock(&vdpasim->lock);
+	old_ready = vq->ready;
 	vq->ready = ready;
-	if (vq->ready)
+	if (vq->ready && !old_ready) {
 		vdpasim_queue_ready(vdpasim, idx);
+	}
 	spin_unlock(&vdpasim->lock);
 }
 


