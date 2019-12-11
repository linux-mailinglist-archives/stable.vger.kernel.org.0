Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6211B839
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfLKPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfLKPHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F8320663;
        Wed, 11 Dec 2019 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076869;
        bh=BO2lxcauj7lLTeQ0jt3g68uT7ooDvMksT5b3CHii7pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kVptygJdEevPJ/GJtORto5q1ZlQqOUFm2oymaXFKlDrT3bNh9d+agb3Ep/b2Kkf/
         VP4f060x4NV3F0KsAvaGAlsXl2tOPWHHatqz7k3v+OEpsl3V0OSB+UH8O5Gi8BAPxn
         nNuAec33pWHTHjF4GGi3a/kWqJMFs5eEkfPwaiAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 21/92] io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR
Date:   Wed, 11 Dec 2019 16:05:12 +0100
Message-Id: <20191211150228.498762084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 441cdbd5449b4923cd413d3ba748124f91388be9 upstream.

We should never return -ERESTARTSYS to userspace, transform it into
-EINTR.

Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1667,6 +1667,8 @@ static int io_send_recvmsg(struct io_kio
 		ret = fn(sock, msg, flags);
 		if (force_nonblock && ret == -EAGAIN)
 			return ret;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 	}
 
 	io_cqring_add_event(req->ctx, sqe->user_data, ret);


