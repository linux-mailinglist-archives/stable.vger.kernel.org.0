Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104066B4987
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjCJPNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbjCJPNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2463123CF6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C9A8B822DE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5B2C433EF;
        Fri, 10 Mar 2023 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460625;
        bh=KV4niEOuyqcpvdW81f1AXcUNnh19cjX0FElblAjoNaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYYXGaoazKFnwzJU9ODQNJAKpft+Fa5vAGOP2q7skfvKYN+PDaSGJQ4loYGqPwrHk
         5+8s0JuhBg1ZmVMEi0AV5YzPbPWjA7W+fTaeQviUZQwVeM3dLLkBPdrx+ic1f2a5zf
         kjMkGUe+bgjhUdtaoq+ambQLWk85HV+ZonUPkm4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 397/529] rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails
Date:   Fri, 10 Mar 2023 14:39:00 +0100
Message-Id: <20230310133823.383708377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -5369,8 +5369,7 @@ static void rbd_dev_release(struct devic
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -5415,9 +5414,6 @@ static struct rbd_device *__rbd_dev_crea
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -5430,12 +5426,10 @@ static struct rbd_device *rbd_dev_create
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
@@ -5452,6 +5446,10 @@ static struct rbd_device *rbd_dev_create
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -6812,7 +6810,7 @@ static int rbd_dev_probe_parent(struct r
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -6822,8 +6820,8 @@ static int rbd_dev_probe_parent(struct r
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
 


