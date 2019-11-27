Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB01C10BB0D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731863AbfK0VJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732841AbfK0VJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5564A2086A;
        Wed, 27 Nov 2019 21:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888943;
        bh=PZy9hinZ6ze5jpbPRfK2kaXbA9P5/EwPVcehz1CEyEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6/G2QlFnVIEYBFnuszlb0t+oYPdoiksoM5p41vEUrV962P/82DPolbYtEUdF+cs+
         xYfwc/Q7+ic2TG7NweFcNVfRa4psdhDs0W/5quZTDM2NCBbTzW71olJ4c0lGhl0UBT
         ueb6esVYEpB2u5vz3iq0Um9RpqEHHV80KX/vUKLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Sun Ke <sunke32@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 23/95] nbd:fix memory leak in nbd_get_socket()
Date:   Wed, 27 Nov 2019 21:31:40 +0100
Message-Id: <20191127202851.552318931@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
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
@@ -956,6 +956,7 @@ static struct socket *nbd_get_socket(str
 	if (sock->ops->shutdown == sock_no_shutdown) {
 		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown callout must be supported.\n");
 		*err = -EINVAL;
+		sockfd_put(sock);
 		return NULL;
 	}
 


