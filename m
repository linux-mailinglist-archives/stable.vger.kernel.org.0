Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D472F7395
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbhAOHRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbhAOHRz (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:17:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FDC822DA7;
        Fri, 15 Jan 2021 07:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610695034;
        bh=IvLPlUROYH7pP2j3BcHVAivWXemmQ4aCFE79fBWZ6k8=;
        h=Subject:To:From:Date:From;
        b=nqK9EyHvdDrhzWtp9trCWVybuCU87hn8Gg/1PUcGmMhwajARysdywPw0iJhuvH7kO
         o2w/rUHJQQVTJXZyyYD/ei4IZ2gF+2BaWvgnqo/pZGz9e/DNOXNHDBR20LXB7+mk5i
         uRDLf/DeeUnjDfRVLlsEvjtfV+YGWpOJDavKgU2o=
Subject: patch "counter:ti-eqep: remove floor" added to staging-linus
To:     david@lechnology.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 08:17:05 +0100
Message-ID: <1610695025189214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    counter:ti-eqep: remove floor

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 49a9565a7a7ce168e3e6482fb24e62d12f72ab81 Mon Sep 17 00:00:00 2001
From: David Lechner <david@lechnology.com>
Date: Sun, 13 Dec 2020 18:09:27 -0600
Subject: counter:ti-eqep: remove floor

The hardware doesn't support this. QPOSINIT is an initialization value
that is triggered by other things. When the counter overflows, it
always wraps around to zero.

Fixes: f213729f6796 "counter: new TI eQEP driver"
Signed-off-by: David Lechner <david@lechnology.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/20201214000927.1793062-1-david@lechnology.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/counter/ti-eqep.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index a60aee1a1a29..65df9ef5b5bc 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -235,36 +235,6 @@ static ssize_t ti_eqep_position_ceiling_write(struct counter_device *counter,
 	return len;
 }
 
-static ssize_t ti_eqep_position_floor_read(struct counter_device *counter,
-					   struct counter_count *count,
-					   void *ext_priv, char *buf)
-{
-	struct ti_eqep_cnt *priv = counter->priv;
-	u32 qposinit;
-
-	regmap_read(priv->regmap32, QPOSINIT, &qposinit);
-
-	return sprintf(buf, "%u\n", qposinit);
-}
-
-static ssize_t ti_eqep_position_floor_write(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *ext_priv, const char *buf,
-					    size_t len)
-{
-	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	u32 res;
-
-	err = kstrtouint(buf, 0, &res);
-	if (err < 0)
-		return err;
-
-	regmap_write(priv->regmap32, QPOSINIT, res);
-
-	return len;
-}
-
 static ssize_t ti_eqep_position_enable_read(struct counter_device *counter,
 					    struct counter_count *count,
 					    void *ext_priv, char *buf)
@@ -301,11 +271,6 @@ static struct counter_count_ext ti_eqep_position_ext[] = {
 		.read	= ti_eqep_position_ceiling_read,
 		.write	= ti_eqep_position_ceiling_write,
 	},
-	{
-		.name	= "floor",
-		.read	= ti_eqep_position_floor_read,
-		.write	= ti_eqep_position_floor_write,
-	},
 	{
 		.name	= "enable",
 		.read	= ti_eqep_position_enable_read,
-- 
2.30.0


