Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89871EEE48
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbfKDWJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390410AbfKDWJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:29 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BCC2205C9;
        Mon,  4 Nov 2019 22:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905369;
        bh=rAJzLnzBVgEPuV8kR1+7VCm/ydjwode9suZJvidJaO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfFB5GuiEk3eLVVUzcpMJ340Z1NTOaU8ZsZjuaGyUdMoNwIKyfar0npfGU8h0DOhV
         Sqcp7UJJ4jXh3/wGWZPRACExJ+0E+P0IEY5myio5+8uWPFfypAkfdJ9/nayR132I07
         TbHJVo9qK9bNQGM9Sb/agBxq3ZG4oWoGsQy0zU7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 121/163] um-ubd: Entrust re-queue to the upper layers
Date:   Mon,  4 Nov 2019 22:45:11 +0100
Message-Id: <20191104212148.975125444@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

commit d848074b2f1eb11a38691285f7366bce83087014 upstream.

Fixes crashes due to ubd requeue logic conflicting with the block-mq
logic. Crash is reproducible in 5.0 - 5.3.

Fixes: 53766defb8c8 ("um: Clean-up command processing in UML UBD driver")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/drivers/ubd_kern.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1403,8 +1403,12 @@ static blk_status_t ubd_queue_rq(struct
 
 	spin_unlock_irq(&ubd_dev->lock);
 
-	if (ret < 0)
-		blk_mq_requeue_request(req, true);
+	if (ret < 0) {
+		if (ret == -ENOMEM)
+			res = BLK_STS_RESOURCE;
+		else
+			res = BLK_STS_DEV_RESOURCE;
+	}
 
 	return res;
 }


