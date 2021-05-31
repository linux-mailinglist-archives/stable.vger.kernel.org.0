Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83E7395E30
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhEaNzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232211AbhEaNxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071696188B;
        Mon, 31 May 2021 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467992;
        bh=fDSHuxrhJTbpqsPwkMi+VT3J276BLyapjLD2nMJdh4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/1y+nJAcD2yIjkXsrtk+diy1fqEw/DDzHKFXnbaBJwtEhxhnuyLaDkep9sItCkc0
         dCTzZeqWD/fL+6DwzqT3Gorx0dyXi/u9z3PZyGsSLq5lYRtV2SlxlusV1BKvFeQpFi
         MbSU+Hq6WzelaD20ejHyejbtDNIJNKR+V5+dUYY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 5.10 075/252] Revert "irqbypass: do not start cons/prod when failed connect"
Date:   Mon, 31 May 2021 15:12:20 +0200
Message-Id: <20210531130700.548488476@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit e44b49f623c77bee7451f1a82ccfb969c1028ae2 upstream.

This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.

The reverted commit may cause VM freeze on arm64 with GICv4,
where stopping a consumer is implemented by suspending the VM.
Should the connect fail, the VM will not be resumed, which
is a bit of a problem.

It also erroneously calls the producer destructor unconditionally,
which is unexpected.

Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
[maz: tags and cc-stable, commit message update]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
Link: https://lore.kernel.org/r/3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com
Link: https://lore.kernel.org/r/20210508071152.722425-1-lingshan.zhu@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/lib/irqbypass.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_p
 	if (prod->add_consumer)
 		ret = prod->add_consumer(prod, cons);
 
-	if (ret)
-		goto err_add_consumer;
-
-	ret = cons->add_producer(cons, prod);
-	if (ret)
-		goto err_add_producer;
+	if (!ret) {
+		ret = cons->add_producer(cons, prod);
+		if (ret && prod->del_consumer)
+			prod->del_consumer(prod, cons);
+	}
 
 	if (cons->start)
 		cons->start(cons);
 	if (prod->start)
 		prod->start(prod);
-err_add_producer:
-	if (prod->del_consumer)
-		prod->del_consumer(prod, cons);
-err_add_consumer:
+
 	return ret;
 }
 


