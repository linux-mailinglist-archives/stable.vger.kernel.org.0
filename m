Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0465148354
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404813AbgAXLfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404631AbgAXLfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:35:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F90214AF;
        Fri, 24 Jan 2020 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865713;
        bh=zHEa6RyqK3/AXhuI0UnHSIyB5967ALnXb+WEQ3VtwPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIphtptR2/4/+pkq8wNF2zV6dboyd6Y+ZiS48qvOzbO3Vqp0I8MzgeFfbKuugW0SR
         vRBtT4ynW8Goy/3/fEan71tmhNp/aKZlMjjqINvg48djVJHrXx839XHK6XTZscIz+8
         8aAeBYy688KfqU5ZwiYcQSV20QMTuXWT3rjBxsgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 605/639] vhost/test: stop device before reset
Date:   Fri, 24 Jan 2020 10:32:55 +0100
Message-Id: <20200124093205.226348560@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 245cdd9fbd396483d501db83047116e2530f245f ]

When device stop was moved out of reset, test device wasn't updated to
stop before reset, this resulted in a use after free.  Fix by invoking
stop appropriately.

Fixes: b211616d7125 ("vhost: move -net specific code out")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a9be2d8e98df7..55090d9f9de0d 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -162,6 +162,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 
 	vhost_test_stop(n, &private);
 	vhost_test_flush(n);
+	vhost_dev_stop(&n->dev);
 	vhost_dev_cleanup(&n->dev);
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
@@ -238,6 +239,7 @@ static long vhost_test_reset_owner(struct vhost_test *n)
 	}
 	vhost_test_stop(n, &priv);
 	vhost_test_flush(n);
+	vhost_dev_stop(&n->dev);
 	vhost_dev_reset_owner(&n->dev, umem);
 done:
 	mutex_unlock(&n->dev.mutex);
-- 
2.20.1



