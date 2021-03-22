Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2883441F1
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCVMhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231796AbhCVMfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B17619AB;
        Mon, 22 Mar 2021 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416534;
        bh=jacjL6WiPCnebx8Q6ICVw7yt8cO++zOZH4qUeV4hk2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esGE4MPEL8D20dFd8HhNUdLFAan4zBog1accUUwcpmHGkplZ5fhWSEKCUlMazvwjQ
         w/qvkY9Vwh4iEK9NbdvrxEdmQBCUXEALJGBVk3Ke6vRx6YoCtCAz3r51upg/11U31N
         JTO9hxZ/DT6tKABWbkFGTM2Pea/hv7gpJ+iovwy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lingshan.zhu@intel.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.10 022/157] vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails
Date:   Mon, 22 Mar 2021 13:26:19 +0100
Message-Id: <20210322121934.476311591@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 0bde59c1723a29e294765c96dbe5c7fb639c2f96 upstream.

In vhost_vdpa_set_config_call() if eventfd_ctx_fdget() fails the
'v->config_ctx' contains an error instead of a valid pointer.

Since we consider 'v->config_ctx' valid if it is not NULL, we should
set it to NULL in this case to avoid to use an invalid pointer in
other functions such as vhost_vdpa_config_put().

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Cc: lingshan.zhu@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210311135257.109460-3-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -335,8 +335,12 @@ static long vhost_vdpa_set_config_call(s
 	if (!IS_ERR_OR_NULL(ctx))
 		eventfd_ctx_put(ctx);
 
-	if (IS_ERR(v->config_ctx))
-		return PTR_ERR(v->config_ctx);
+	if (IS_ERR(v->config_ctx)) {
+		long ret = PTR_ERR(v->config_ctx);
+
+		v->config_ctx = NULL;
+		return ret;
+	}
 
 	v->vdpa->config->set_config_cb(v->vdpa, &cb);
 


