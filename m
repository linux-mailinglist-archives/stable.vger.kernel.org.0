Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D36B4462
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjCJOXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjCJOXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:23:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9220611AB97
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2832CE290C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96FAC433D2;
        Fri, 10 Mar 2023 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458147;
        bh=7fSwCMymNBDW6iX6URjxPMkq5fAjqtYYusAOuC6ryVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcpQmtBqIxgZQexMtjzBqVZ2rTLJ+xdnBtIzbJbuapLYqbZi8TuqzwQqWAgGcJ3iI
         6OLAVdFlDf21wpd29EDz8pOWsDp1ogNEMNUS04S1eLJ+3d+MfV9zuwGYuUqqGmeozj
         Kiktx0+G4WU5YczSooLhSxpXZr9H2YGCmHN7Iocc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.19 179/252] rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails
Date:   Fri, 10 Mar 2023 14:39:09 +0100
Message-Id: <20230310133724.298376649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit f7c4d9b133c7a04ca619355574e96b6abf209fba upstream.

If getting an ID or setting up a work queue in rbd_dev_create() fails,
use-after-free on rbd_dev->rbd_client, rbd_dev->spec and rbd_dev->opts
is triggered in do_rbd_add().  The root cause is that the ownership of
these structures is transfered to rbd_dev prematurely and they all end
up getting freed when rbd_dev_create() calls rbd_dev_free() prior to
returning to do_rbd_add().

Found by Linux Verification Center (linuxtesting.org) with SVACE, an
incomplete patch submitted by Natalia Petrova <n.petrova@fintech.ru>.

Cc: stable@vger.kernel.org
Fixes: 1643dfa4c2c8 ("rbd: introduce a per-device ordered workqueue")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4381,8 +4381,7 @@ static void rbd_dev_release(struct devic
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -4421,9 +4420,6 @@ static struct rbd_device *__rbd_dev_crea
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -4436,12 +4432,10 @@ static struct rbd_device *rbd_dev_create
 {
 	struct rbd_device *rbd_dev;
 
-	rbd_dev = __rbd_dev_create(rbdc, spec);
+	rbd_dev = __rbd_dev_create(spec);
 	if (!rbd_dev)
 		return NULL;
 
-	rbd_dev->opts = opts;
-
 	/* get an id and fill in device name */
 	rbd_dev->dev_id = ida_simple_get(&rbd_dev_id_ida, 0,
 					 minor_to_rbd_dev_id(1 << MINORBITS),
@@ -4458,6 +4452,10 @@ static struct rbd_device *rbd_dev_create
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -5618,7 +5616,7 @@ static int rbd_dev_probe_parent(struct r
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -5628,8 +5626,8 @@ static int rbd_dev_probe_parent(struct r
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	ret = rbd_dev_image_probe(parent, depth);
 	if (ret < 0)


