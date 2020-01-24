Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C88147D08
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgAXJ4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733156AbgAXJ4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:56:24 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C60D20718;
        Fri, 24 Jan 2020 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859783;
        bh=Nym0iD4z5NaCeFn5Wys1xYI74+4vhLSYjFRC9SEUaek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oefFpxuUt4z3jBM3kM84L/2QTUCPid0IFm64oHMfBOoZLrUdr3+OIzis31F2xEa9
         rYRcT5lQk42g+oHn2jjeAbagKdJR2pudTYAlW0Zw2IeSZBC+jVLV1KPUzDWMPY75Nt
         dZ8pnum9Gqib+7hbfmTxFRCZIWpQTmWvfRHGlrPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Konopko <igor.j.konopko@intel.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 194/343] lightnvm: pblk: fix lock order in pblk_rb_tear_down_check
Date:   Fri, 24 Jan 2020 10:30:12 +0100
Message-Id: <20200124092945.501276564@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Konopko <igor.j.konopko@intel.com>

[ Upstream commit 486b5aac85f6ec0b2df3e82a6a629d5eb7804db5 ]

In pblk_rb_tear_down_check() the spinlock functions are not
called in proper order.

Fixes: a4bd217 ("lightnvm: physical block device (pblk) target")
Signed-off-by: Igor Konopko <igor.j.konopko@intel.com>
Reviewed-by: Javier González <javier@javigon.com>
Reviewed-by: Hans Holmberg <hans.holmberg@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lightnvm/pblk-rb.c b/drivers/lightnvm/pblk-rb.c
index c0dd17a821709..73de2deaba673 100644
--- a/drivers/lightnvm/pblk-rb.c
+++ b/drivers/lightnvm/pblk-rb.c
@@ -825,8 +825,8 @@ int pblk_rb_tear_down_check(struct pblk_rb *rb)
 	}
 
 out:
-	spin_unlock(&rb->w_lock);
 	spin_unlock_irq(&rb->s_lock);
+	spin_unlock(&rb->w_lock);
 
 	return ret;
 }
-- 
2.20.1



