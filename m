Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E915C3FDB6B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhIAMlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344661AbhIAMjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B1E610CF;
        Wed,  1 Sep 2021 12:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499740;
        bh=wcH7vU2eTeQRAkcXC8NdS1JplMlqCQXC0XZMfkTE6z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZfCutLwdShNLNECQ9462PpzDL5HHdT70VVeYzx30jjLdP//y5VRm/3Ow2HqOTXwK
         xgOh4H9FTQchw56p1DVlKpAaTYabZMsfJUtO4l62YDPWJcIFrUj+NUuP5NtE4OduZf
         RfJSVBX/BsadMR5jtAiYtDiYhk4+21TQiyPyxI1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/103] vringh: Use wiov->used to check for read/write desc order
Date:   Wed,  1 Sep 2021 14:28:10 +0200
Message-Id: <20210901122302.584020524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

[ Upstream commit e74cfa91f42c50f7f649b0eca46aa049754ccdbd ]

As __vringh_iov() traverses a descriptor chain, it populates
each descriptor entry into either read or write vring iov
and increments that iov's ->used member. So, as we iterate
over a descriptor chain, at any point, (riov/wriov)->used
value gives the number of descriptor enteries available,
which are to be read or written by the device. As all read
iovs must precede the write iovs, wiov->used should be zero
when we are traversing a read descriptor. Current code checks
for wiov->i, to figure out whether any previous entry in the
current descriptor chain was a write descriptor. However,
iov->i is only incremented, when these vring iovs are consumed,
at a later point, and remain 0 in __vringh_iov(). So, correct
the check for read and write descriptor order, to use
wiov->used.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Link: https://lore.kernel.org/r/1624591502-4827-1-git-send-email-neeraju@codeaurora.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index b7403ba8e7f7..0bd7e64331f0 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -341,7 +341,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			iov = wiov;
 		else {
 			iov = riov;
-			if (unlikely(wiov && wiov->i)) {
+			if (unlikely(wiov && wiov->used)) {
 				vringh_bad("Readable desc %p after writable",
 					   &descs[i]);
 				err = -EINVAL;
-- 
2.30.2



