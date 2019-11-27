Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17810BE85
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfK0Ur5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfK0Ur4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:47:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAC77217D6;
        Wed, 27 Nov 2019 20:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887676;
        bh=2+2UrcNQKOmqNWVIJvaoWFdOKn0xaQmXMVSbHEEMVUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvFZOTzIqDtl023kc7So7Lm3jYPldOdB714+9Sg2gvaqGkb5cWCU82Hv2Yk1d95zX
         OsE4gV73bnkImbtQm2mnHMViACfIzJC1dK0oeWbpIVAyxrxT6Za+4zNASqTj+foznJ
         jASvk6rBObySZhp/xbKx1kDLzV4JVZYLlp5WsrFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Sun Ke <sunke32@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 010/211] nbd:fix memory leak in nbd_get_socket()
Date:   Wed, 27 Nov 2019 21:29:03 +0100
Message-Id: <20191127203050.799096716@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sun Ke <sunke32@huawei.com>

commit dff10bbea4be47bdb615b036c834a275b7c68133 upstream.

Before returning NULL, put the sock first.

Cc: stable@vger.kernel.org
Fixes: cf1b2326b734 ("nbd: verify socket is supported during setup")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Sun Ke <sunke32@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nbd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -931,6 +931,7 @@ static struct socket *nbd_get_socket(str
 	if (sock->ops->shutdown == sock_no_shutdown) {
 		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown callout must be supported.\n");
 		*err = -EINVAL;
+		sockfd_put(sock);
 		return NULL;
 	}
 


