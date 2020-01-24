Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52224148154
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbgAXLS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390732AbgAXLS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:59 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629912077C;
        Fri, 24 Jan 2020 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864739;
        bh=jchwoRYGdw5u05s9Q3W2XMDv3EKFMsWmDZcOvPvSGSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agdUuy5q2pX/mUu8fM9AxUHneS97zZzf1n4k21Z8piCHKK/9KSRNnxb1errLN6SBw
         ELuaZoy6UOhoKGQYpAOZUfElDtpgtsHziR63niIWBy8pMvvBopn4FcJhKTQ5d811u9
         EHrFk1adFx9Nd+ZofqTbQjIfJcqnx9y1qEfofHgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Konopko <igor.j.konopko@intel.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 352/639] lightnvm: pblk: fix lock order in pblk_rb_tear_down_check
Date:   Fri, 24 Jan 2020 10:28:42 +0100
Message-Id: <20200124093131.204616416@linuxfoundation.org>
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
index f6eec0212dfcf..d22c13b556221 100644
--- a/drivers/lightnvm/pblk-rb.c
+++ b/drivers/lightnvm/pblk-rb.c
@@ -784,8 +784,8 @@ int pblk_rb_tear_down_check(struct pblk_rb *rb)
 	}
 
 out:
-	spin_unlock(&rb->w_lock);
 	spin_unlock_irq(&rb->s_lock);
+	spin_unlock(&rb->w_lock);
 
 	return ret;
 }
-- 
2.20.1



