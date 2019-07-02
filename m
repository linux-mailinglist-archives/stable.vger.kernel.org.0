Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245575CB9B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGBIFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfGBIFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE13121479;
        Tue,  2 Jul 2019 08:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054751;
        bh=S+DIEFDqaSmUJzNhm1v6tI65Wx7tRIHzy5KPod8TXuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6jY+/ntDCuvr3ultDbUmfg0KQyP9N0pEzF11KgNQlDOOPF0Phbx2/R2s81o9VLVO
         4KYdMhgeSeqQyED0e/pnYdk7Ac03VWidvRqxXYIRVnh+L7mQV3dHpa9v+ivJhbNct6
         VDrqS+HbtoK2h6e+mv0hfEnxTN6fPv+zNtzqRIi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/72] 9p/xen: fix check for xenbus_read error in front_probe
Date:   Tue,  2 Jul 2019 10:01:08 +0200
Message-Id: <20190702080124.947283085@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2f9ad0ac947ccbe3ffe7c6229c9330f2a7755f64 ]

If the xen bus exists but does not expose the proper interface, it is
possible to get a non-zero length but still some error, leading to
strcmp failing trying to load invalid memory addresses e.g.
fffffffffffffffe.

There is then no need to check length when there is no error, as the
xenbus driver guarantees that the string is nul-terminated.

Link: http://lkml.kernel.org/r/1534236007-10170-1-git-send-email-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index c2d54ac76bfd..843cb823d9b9 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -391,8 +391,8 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	unsigned int max_rings, max_ring_order, len = 0;
 
 	versions = xenbus_read(XBT_NIL, dev->otherend, "versions", &len);
-	if (!len)
-		return -EINVAL;
+	if (IS_ERR(versions))
+		return PTR_ERR(versions);
 	if (strcmp(versions, "1")) {
 		kfree(versions);
 		return -EINVAL;
-- 
2.20.1



