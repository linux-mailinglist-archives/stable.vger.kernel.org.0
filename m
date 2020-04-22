Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733F91B3DE9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgDVKWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgDVKVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FE5720781;
        Wed, 22 Apr 2020 10:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550893;
        bh=VEd9/hHSI2LM9QifGfHozkesULLQcwBlXWnlKyhmCus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncn9ducF6fPJAF3x0VeLd5UMjoKSBd9IDj7keIeZVmbNeN9g7VwM1AjEETi6zWQLV
         zAFC29NPTuYnIH1RmbZzcivRyVDNUP21uBQje68a1hPwR3Vxj13MjarliKggAs9Xw8
         kX+epsPsJqNPQUa1//5eg5JAvdrwblkDc9PQ5pcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jason Dillaman <dillaman@redhat.com>
Subject: [PATCH 5.6 018/166] rbd: dont test rbd_dev->opts in rbd_dev_image_release()
Date:   Wed, 22 Apr 2020 11:55:45 +0200
Message-Id: <20200422095050.379977098@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit b8776051529230f76e464d5ffc5d1cf8465576bf upstream.

rbd_dev->opts is used to distinguish between the image that is being
mapped and a parent.  However, because we no longer establish watch for
read-only mappings, this test is imprecise and results in unnecessary
rbd_unregister_watch() calls.

Make it consistent with need_watch in rbd_dev_image_probe().

Fixes: b9ef2b8858a0 ("rbd: don't establish watch for read-only mappings")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jason Dillaman <dillaman@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6955,7 +6955,7 @@ static void rbd_print_dne(struct rbd_dev
 
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
-	if (rbd_dev->opts)
+	if (!rbd_is_ro(rbd_dev))
 		rbd_unregister_watch(rbd_dev);
 
 	rbd_dev_unprobe(rbd_dev);


