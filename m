Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D52F166508
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 18:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgBTRhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 12:37:38 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46742 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgBTRhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 12:37:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so2236369pfp.13;
        Thu, 20 Feb 2020 09:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kJSXURi17GaZNBPP0JzcsPR2iR7Cn6Nw/QvOcKOXUPo=;
        b=Yxd42H7IRMldkJRd27VpBEePGf27gJnokv+p3ly2v/y5c0C1Z6jbZSQuQ2QR5z2rIO
         9SOwkfzqGaYOv8MQExVergqESF5GA/Gx9AddqnWQ1zDLP0UavTKBlbsWHiIDZZWDh6ly
         SkSI9FZGoc8ZsXfSjyw1orpOHfeJEgiHAEnyOsQHzY4TkPIXY+JWCtuERlQgLIgwA80D
         GHbDnEG3ZdWwWJ9/Ilup32w4KiVjhhK1iOBfGBnRpUpe1X0cdWBBzLBrOXQUT3rJ04s+
         77lqXgFXuPWI1G3FOj16n15kQDqSdoUyWltrzhFH/SIXlxD7P3/Aml8/jaC7Od0gZ1v+
         6eJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kJSXURi17GaZNBPP0JzcsPR2iR7Cn6Nw/QvOcKOXUPo=;
        b=iUFlRR+Qr6E+Dhmoxj6EixPWbreBnPZhZFYlx7nuMmhPqydTSPLS9VxAzEclWYtMq/
         df5s49r7cjzZ+en43PEnwSTXznsjym6B9KCmP3hD5fhHfub0EQ+LreEBN9ciC/oNv5AL
         WPlVkuVIsMA20lrkOI1vvMdI0DM9vc29pj9SsJRGWsLtz6aLi9nef1QQjaqBacJc682c
         9/l6m7KgoxVGuplGDH3TOd64s4cB3ZszWkhj8HTKRYzexVjVPRZwY44jvEIqZ9dSecCG
         sIKM5RxNh9BSnKeAT/UwJFdBZ2h2UV8Wpw3FgM6x9VrqT6kz1vz7/96HFp9yEYQAdkLS
         cncQ==
X-Gm-Message-State: APjAAAXdG3f1FpWkG1qFUQsEvfNzsixJ/NsV06jQXQt9eTfhCjhgKg7d
        e2hf79jwo6c7PQpHT/U/rDc=
X-Google-Smtp-Source: APXvYqyZXr3vYDThysmYFmbmihtsW5OqKsNuPAqTPzdorr7OnlKMuEGOFT+vsTmOF3HRJ/yCa5Ez7A==
X-Received: by 2002:a63:be48:: with SMTP id g8mr35351706pgo.23.1582220256810;
        Thu, 20 Feb 2020 09:37:36 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id m18sm4240960pgd.39.2020.02.20.09.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Feb 2020 09:37:35 -0800 (PST)
From:   Orson Zhai <orson.unisoc@gmail.com>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, mingmin.ling@unisoc.com,
        orsonzhai@gmail.com, jingchao.ye@unisoc.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Orson Zhai <orson.unisoc@gmail.com>
Subject: [PATCH] Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"
Date:   Fri, 21 Feb 2020 01:37:04 +0800
Message-Id: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
 drivers/devfreq/devfreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index cceee8b..7dcf209 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
 {
 	struct devfreq *devfreq;
 	struct devfreq_governor *governor;
-	static atomic_t devfreq_no = ATOMIC_INIT(-1);
 	int err = 0;
 
 	if (!dev || !profile || !governor_name) {
@@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
 	atomic_set(&devfreq->suspend_count, 0);
 
-	dev_set_name(&devfreq->dev, "devfreq%d",
-				atomic_inc_return(&devfreq_no));
+	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		mutex_unlock(&devfreq->lock);
-- 
2.7.4

