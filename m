Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF88047AD9E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbhLTOx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbhLTOvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3789C08EAF8;
        Mon, 20 Dec 2021 06:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B8E611A0;
        Mon, 20 Dec 2021 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401B3C36AE8;
        Mon, 20 Dec 2021 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011613;
        bh=PVqadq8hl8c6URqJ9pFTI1tVpCMthjYsXme+yNBIdKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9rkJtIlHBYQPEE+V5rZgiL0qN39HyCAFKterd2BfP8p6iQZxagDzXwdqklf7U7/G
         zqOYf5ByQX/86MFwEdk/UFW0j9XUHJzPNEcBrAhdtZALuTp+DoZy+9do3PcUxzpth/
         391t2xb/rqF6YjK/jAymuYgSaKasZUKaReBR9z/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 12/99] vdpa: check that offsets are within bounds
Date:   Mon, 20 Dec 2021 15:33:45 +0100
Message-Id: <20211220143029.761728936@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
@@ -196,7 +196,7 @@ static int vhost_vdpa_config_validate(st
 		break;
 	}
 
-	if (c->len == 0)
+	if (c->len == 0 || c->off > size)
 		return -EINVAL;
 
 	if (c->len > size - c->off)


