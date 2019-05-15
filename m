Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843381F221
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfEOLN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbfEOLNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:13:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DED42168B;
        Wed, 15 May 2019 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918803;
        bh=mDS7U+WjhmJkdMvliJsBtFb47LJZkRupeS47ii3XgW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVL5NlFcXx0FfAxd8DRPgzaIQpm5B0511raafjmmY5mL54Ybf+CWCdfgqt4KBPq1Z
         56r/wkVD4cKg4GrInr5nZc3TSp0slB+MnWuOOVAQANs6i/Pg244bQ1bEaEX+J7Y/3f
         FqkozswByDW1rO5LPA5CzpfPMqHce06ed2Ro9W7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tobin C. Harding" <tobin@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 257/266] bridge: Fix error path for kobject_init_and_add()
Date:   Wed, 15 May 2019 12:56:04 +0200
Message-Id: <20190515090731.710145644@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tobin C. Harding" <tobin@kernel.org>

[ Upstream commit bdfad5aec1392b93495b77b864d58d7f101dc1c1 ]

Currently error return from kobject_init_and_add() is not followed by a
call to kobject_put().  This means there is a memory leak.  We currently
set p to NULL so that kfree() may be called on it as a noop, the code is
arguably clearer if we move the kfree() up closer to where it is
called (instead of after goto jump).

Remove a goto label 'err1' and jump to call to kobject_put() in error
return from kobject_init_and_add() fixing the memory leak.  Re-name goto
label 'put_back' to 'err1' now that we don't use err1, following current
nomenclature (err1, err2 ...).  Move call to kfree out of the error
code at bottom of function up to closer to where memory was allocated.
Add comment to clarify call to kfree().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_if.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -471,13 +471,15 @@ int br_add_if(struct net_bridge *br, str
 	call_netdevice_notifiers(NETDEV_JOIN, dev);
 
 	err = dev_set_allmulti(dev, 1);
-	if (err)
-		goto put_back;
+	if (err) {
+		kfree(p);	/* kobject not yet init'd, manually free */
+		goto err1;
+	}
 
 	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
 				   SYSFS_BRIDGE_PORT_ATTR);
 	if (err)
-		goto err1;
+		goto err2;
 
 	err = br_sysfs_addif(p);
 	if (err)
@@ -551,12 +553,9 @@ err3:
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
 	kobject_put(&p->kobj);
-	p = NULL; /* kobject_put frees */
-err1:
 	dev_set_allmulti(dev, -1);
-put_back:
+err1:
 	dev_put(dev);
-	kfree(p);
 	return err;
 }
 


