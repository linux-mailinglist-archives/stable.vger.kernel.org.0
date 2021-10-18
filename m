Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C71431E72
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhJROBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhJRN7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF6461458;
        Mon, 18 Oct 2021 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564502;
        bh=zcbKeoz81sQDHvnq/SiQbn4QYyl4Aqi3Pgn42io0wuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rfw19Wrz+A40n5M51S60C+RlTnc8LFBsO192H5RyY3WfOKevtuNcsy1rRHZR47QO
         52ER+AZV56/0wReB4F6Lc+VrDYQ8fXAwWyZDOO8RaQFGw+uNF8VXzoxEqoExYVSaCM
         mO7eQ9HSV3t5pvAoA6fuqZb0Lu6YwogpdPu8Mqz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.14 114/151] vhost-vdpa: Fix the wrong input in config_cb
Date:   Mon, 18 Oct 2021 15:24:53 +0200
Message-Id: <20211018132344.384968061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -316,7 +316,7 @@ static long vhost_vdpa_set_config_call(s
 	struct eventfd_ctx *ctx;
 
 	cb.callback = vhost_vdpa_config_cb;
-	cb.private = v->vdpa;
+	cb.private = v;
 	if (copy_from_user(&fd, argp, sizeof(fd)))
 		return  -EFAULT;
 


