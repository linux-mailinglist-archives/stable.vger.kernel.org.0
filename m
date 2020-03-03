Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3235317811B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgCCSAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387814AbgCCSAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990A52072D;
        Tue,  3 Mar 2020 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258439;
        bh=U79f2KH8oegSSdb7QtGP/IXx/JFv49iQpTTomm8CTB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trOVaWZO/s7coA3AqI2FC3V0tzWGOvCezyVCxW+7zVasGxjnmcndjLXwWnszpfZnw
         ENdMNeol67gUnH45s0jujxrxE72W5aGPou8tz1vv8AKWArjiEtyoO4gSCGRdxK9buF
         ctIACk9n6v8zM64xuQLoLC6icXM9OKypr+eBJqvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4.19 49/87] Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"
Date:   Tue,  3 Mar 2020 18:43:40 +0100
Message-Id: <20200303174354.746201966@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
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
@@ -600,7 +600,6 @@ struct devfreq *devfreq_add_device(struc
 {
 	struct devfreq *devfreq;
 	struct devfreq_governor *governor;
-	static atomic_t devfreq_no = ATOMIC_INIT(-1);
 	int err = 0;
 
 	if (!dev || !profile || !governor_name) {
@@ -661,8 +660,7 @@ struct devfreq *devfreq_add_device(struc
 	}
 	devfreq->max_freq = devfreq->scaling_max_freq;
 
-	dev_set_name(&devfreq->dev, "devfreq%d",
-				atomic_inc_return(&devfreq_no));
+	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		mutex_unlock(&devfreq->lock);


