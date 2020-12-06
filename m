Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905612D0414
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgLFLnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbgLFLnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:03 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 27/39] vxlan: fix error return code in __vxlan_dev_create()
Date:   Sun,  6 Dec 2020 12:17:31 +0100
Message-Id: <20201206111555.984668459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 832e09798c261cf58de3a68cfcc6556408c16a5a ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1606903122-2098-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3617,8 +3617,10 @@ static int __vxlan_dev_create(struct net
 
 	if (dst->remote_ifindex) {
 		remote_dev = __dev_get_by_index(net, dst->remote_ifindex);
-		if (!remote_dev)
+		if (!remote_dev) {
+			err = -ENODEV;
 			goto errout;
+		}
 
 		err = netdev_upper_dev_link(remote_dev, dev, extack);
 		if (err)


