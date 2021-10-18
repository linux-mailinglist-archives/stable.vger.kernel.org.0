Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C92431D5A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhJRNuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234085AbhJRNs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8660B615E6;
        Mon, 18 Oct 2021 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564223;
        bh=HsUcOVXCV/LUQslWbaEvlU0ZzUFt/94EE7hHsXdfuDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNRGqcZ/0VadndppOuU8cnPYaF8DCabBwmnj5d2TtB2LT7uv1TWUDmXOMYWf8B1aa
         VlJ33YoJ9zKPeRxxz5sPWTsAyPz+d4uev08opVnF3R4zXk3nQwowu/ug4qcle6lONx
         nOm2KIVCjC1SzO24CPz4iMVYuwwgbP0s5riMuUMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 078/103] vhost-vdpa: Fix the wrong input in config_cb
Date:   Mon, 18 Oct 2021 15:24:54 +0200
Message-Id: <20211018132337.370766466@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cindy Lu <lulu@redhat.com>

commit bcef9356fc2e1302daf373c83c826aa27954d128 upstream.

Fix the wrong input in for config_cb. In function vhost_vdpa_config_cb,
the input cb.private was used as struct vhost_vdpa, so the input was
wrong here, fix this issue

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Signed-off-by: Cindy Lu <lulu@redhat.com>
Link: https://lore.kernel.org/r/20210929090933.20465-1-lulu@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -325,7 +325,7 @@ static long vhost_vdpa_set_config_call(s
 	struct eventfd_ctx *ctx;
 
 	cb.callback = vhost_vdpa_config_cb;
-	cb.private = v->vdpa;
+	cb.private = v;
 	if (copy_from_user(&fd, argp, sizeof(fd)))
 		return  -EFAULT;
 


