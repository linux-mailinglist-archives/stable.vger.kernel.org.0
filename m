Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3453647ADE8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbhLTO4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41982 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbhLTOwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6687611B6;
        Mon, 20 Dec 2021 14:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACCCC36AE8;
        Mon, 20 Dec 2021 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011941;
        bh=B2msg64uIg3ItVlPTyDZwRYGRy7L0/X4y0dJpuFZU0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIDVVrmHhdzOrJhaf4mSpQaO2JNucdD9+7POzGracjODXLzosIzIhIjgbhglQj9Ap
         z0BxX5Yg9nXTun2PmfhM03PkG0O9qoN7gt4Jzag0yjZmSmLW7PvA6V23X4+0hfMeq7
         1Rh5vszberABPTNkuonVzrNLhoW65dEKw/+a4MlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 023/177] vdpa: check that offsets are within bounds
Date:   Mon, 20 Dec 2021 15:32:53 +0100
Message-Id: <20211220143040.854780516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3ed21c1451a14d139e1ceb18f2fa70865ce3195a upstream.

In this function "c->off" is a u32 and "size" is a long.  On 64bit systems
if "c->off" is greater than "size" then "size - c->off" is a negative and
we always return -E2BIG.  But on 32bit systems the subtraction is type
promoted to a high positive u32 value and basically any "c->len" is
accepted.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Reported-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211208103337.GA4047@kili
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -197,7 +197,7 @@ static int vhost_vdpa_config_validate(st
 	struct vdpa_device *vdpa = v->vdpa;
 	long size = vdpa->config->get_config_size(vdpa);
 
-	if (c->len == 0)
+	if (c->len == 0 || c->off > size)
 		return -EINVAL;
 
 	if (c->len > size - c->off)


