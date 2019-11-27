Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E494210B9D8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfK0U5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731165AbfK0U5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265102084D;
        Wed, 27 Nov 2019 20:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888235;
        bh=2tfT+JNrdVWZ+oMRcmgZUtHbBrEltXM0CPEOcEo0S8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJgBCY77HGP9bXTN45g+s93V4pMECjuF0jogJF371dcLcHlv2TUL0EuHSww6uB6lO
         UG9VX4EASi7pkixuUKPtDCBmFFbKCqMPBdYETWVqVO1Q26IL2xQZ3JiUC7gtIRSvjI
         6cpT4IUS+sq71WN+yXzmpQld120XIpJlwQy09W2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Sun Ke <sunke32@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 014/306] nbd:fix memory leak in nbd_get_socket()
Date:   Wed, 27 Nov 2019 21:27:44 +0100
Message-Id: <20191127203115.750394671@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -945,6 +945,7 @@ static struct socket *nbd_get_socket(str
 	if (sock->ops->shutdown == sock_no_shutdown) {
 		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown callout must be supported.\n");
 		*err = -EINVAL;
+		sockfd_put(sock);
 		return NULL;
 	}
 


