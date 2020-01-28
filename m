Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC9114BA65
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgA1OSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbgA1OSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:18:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9FF24688;
        Tue, 28 Jan 2020 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221117;
        bh=dZTUZ43rZtLVx6WjxbjKYrBOrk1kquAKKQ3mzcwZK8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEkzv1pbqMLUjPhsX+PoGF/gikgj80gfAWYC+ViYbjFJA9pZo0yC0gzwzwF7HVk0/
         soe0KZfEsMs92OVL3vCR4EAhBprJT2Udd2TxLD3krY8lRhVgh2fsLGQvcQ4E+PrjfS
         plLwqQJUhSabWmxFQXnm/zxE/EVXHI+S77/RKmHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 095/271] drivers/rapidio/rio_cm.c: fix potential oops in riocm_ch_listen()
Date:   Tue, 28 Jan 2020 15:04:04 +0100
Message-Id: <20200128135859.668659525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5ac188b12e7cbdd92dee60877d1fac913fc1d074 ]

If riocm_get_channel() fails, then we should just return -EINVAL.
Calling riocm_put_channel() will trigger a NULL dereference and
generally we should call put() if the get() didn't succeed.

Link: http://lkml.kernel.org/r/20190110130230.GB27017@kadam
Fixes: b6e8d4aa1110 ("rapidio: add RapidIO channelized messaging driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio_cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
index ef989a15aefc4..b29fc258eeba4 100644
--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -1215,7 +1215,9 @@ static int riocm_ch_listen(u16 ch_id)
 	riocm_debug(CHOP, "(ch_%d)", ch_id);
 
 	ch = riocm_get_channel(ch_id);
-	if (!ch || !riocm_cmp_exch(ch, RIO_CM_CHAN_BOUND, RIO_CM_LISTEN))
+	if (!ch)
+		return -EINVAL;
+	if (!riocm_cmp_exch(ch, RIO_CM_CHAN_BOUND, RIO_CM_LISTEN))
 		ret = -EINVAL;
 	riocm_put_channel(ch);
 	return ret;
-- 
2.20.1



