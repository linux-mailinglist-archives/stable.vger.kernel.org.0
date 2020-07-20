Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBF226968
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgGTQZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732580AbgGTQBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B4F20672;
        Mon, 20 Jul 2020 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260913;
        bh=jMZAkAiRPeB/WryBfB1XZTDKBjG80bl3r5X+Z+hlUPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMLxIox4RwUF3/5VCOR2C0vLQK1vAXvsEoO4jPaJ3hoKrA8XoWjXhX/KDjyQHQoaY
         Yrru4OI66Wdky51SaBdA8SiZvldxgNZGYP/KZ6w6XGSHHHWWmxBFMZtG88Jr5R5gpG
         DuhfjReKoJ4gG84LUMnrzGcyDQdDCZRlbetKYbYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 142/215] slimbus: core: Fix mismatch in of_node_get/put
Date:   Mon, 20 Jul 2020 17:37:04 +0200
Message-Id: <20200720152826.945432247@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit 01360857486c0e4435dea3aa2f78b47213b7cf6a upstream.

Adding missing corresponding of_node_put

Fixes: 7588a511bdb4 ("slimbus: core: add support to device tree helper")
Signed-off-by: Saravana Kannan <saravanak@google.com>
[Srini: added fixes tag, removed NULL check and updated log]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200511151334.362-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/slimbus/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -283,6 +283,7 @@ EXPORT_SYMBOL_GPL(slim_register_controll
 /* slim_remove_device: Remove the effect of slim_add_device() */
 static void slim_remove_device(struct slim_device *sbdev)
 {
+	of_node_put(sbdev->dev.of_node);
 	device_unregister(&sbdev->dev);
 }
 


