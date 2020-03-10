Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E84217FAA9
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgCJNHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbgCJNHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC12820873;
        Tue, 10 Mar 2020 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845632;
        bh=L4GuVXoTq7O5uw5g59v/PoU95cHmnlV73fAbYuaKBlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s37TyZgQ7e3LdAwtaQs59tWIRbmqf+mBgo2+z73TsRIKb5BhWWJtSW42Ow+6b6FMS
         uqJiwRXaS58hr3c6ZepEjwd5UJI37Fswb4RfYv5Rmw7x6JBNQCGAp/N38l7iFY/WJ0
         h+628HN28YC8yxHCK4uSVavTRtI/Q+ipmy/dcxbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4.14 043/126] Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"
Date:   Tue, 10 Mar 2020 13:41:04 +0100
Message-Id: <20200310124207.071001442@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orson Zhai <orson.unisoc@gmail.com>

commit 66d0e797bf095d407479c89952d42b1d96ef0a7f upstream.

This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.

The name changing as devfreq(X) breaks some user space applications,
such as Android HAL from Unisoc and Hikey [1].
The device name will be changed unexpectly after every boot depending
on module init sequence. It will make trouble to setup some system
configuration like selinux for Android.

So we'd like to revert it back to old naming rule before any better
way being found.

[1] https://lkml.org/lkml/2018/5/8/1042

Cc: John Stultz <john.stultz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/devfreq/devfreq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -513,7 +513,6 @@ struct devfreq *devfreq_add_device(struc
 {
 	struct devfreq *devfreq;
 	struct devfreq_governor *governor;
-	static atomic_t devfreq_no = ATOMIC_INIT(-1);
 	int err = 0;
 
 	if (!dev || !profile || !governor_name) {
@@ -556,8 +555,7 @@ struct devfreq *devfreq_add_device(struc
 		mutex_lock(&devfreq->lock);
 	}
 
-	dev_set_name(&devfreq->dev, "devfreq%d",
-				atomic_inc_return(&devfreq_no));
+	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		mutex_unlock(&devfreq->lock);


