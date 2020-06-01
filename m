Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD21EA933
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgFAR7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgFAR7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:59:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2AC2074B;
        Mon,  1 Jun 2020 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034349;
        bh=xC9hJYuRSl5pnTM9TMOSwz7SgPWF7neADVLAEPjyJ74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz/bcbfskZANeqYhjYtEL92ee6jG2hyLp4YMBCcTv6Tc6WAOvibXxlgR04p6lsCgu
         93UPm+0C8meGsivWvjFJ7h0uEhbakiQfKxqj30UtwuRbSgShe/uKW/9M1yNsW+/GTq
         DoQWYOMvhMIj2qBFz+odj/n1psTfhMqSj1vD+4So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 54/61] bonding: Fix reference count leak in bond_sysfs_slave_add.
Date:   Mon,  1 Jun 2020 19:54:01 +0200
Message-Id: <20200601174021.571162466@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit a068aab42258e25094bc2c159948d263ed7d7a77 upstream.

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/bonding/bond_sysfs_slave.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -153,8 +153,10 @@ int bond_sysfs_slave_add(struct slave *s
 
 	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
 				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err)
+	if (err) {
+		kobject_put(&slave->kobj);
 		return err;
+	}
 
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));


