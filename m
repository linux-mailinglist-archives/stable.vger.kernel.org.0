Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF26150C92
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgBCQhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbgBCQhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:39 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF652087E;
        Mon,  3 Feb 2020 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747858;
        bh=arkCkF1UEbJgqIxSxjBDGOgeiZF1m899vWxR5mhEmjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+U5i5fo9EU+UQ7/L5eJIi8WiTj67/q4K2rbp4ApQEwIC2CN6zPda0SzQjfgEHSR2
         tKsCcLkZGcFOoecE+vgagYb22U2o/xz5NR3VCxZfHgC8b/xf4uHw3mkW59wITU7bT0
         OGCGEWGfYYTWOS41cMkEfVgPB8kqbSfGdCFF+mL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.5 10/23] PM / devfreq: Add new name attribute for sysfs
Date:   Mon,  3 Feb 2020 16:20:30 +0000
Message-Id: <20200203161904.709880157@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
References: <20200203161902.288335885@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

commit 2fee1a7cc6b1ce6634bb0f025be2c94a58dfa34d upstream.

The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
sysfs") changed the node name to devfreq(x). After this commit, it is not
possible to get the device name through /sys/class/devfreq/devfreq(X)/*.

Add new name attribute in order to get device name.

Cc: stable@vger.kernel.org
Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/ABI/testing/sysfs-class-devfreq |    7 +++++++
 drivers/devfreq/devfreq.c                     |    9 +++++++++
 2 files changed, 16 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -7,6 +7,13 @@ Description:
 		The name of devfreq object denoted as ... is same as the
 		name of device using devfreq.
 
+What:		/sys/class/devfreq/.../name
+Date:		November 2019
+Contact:	Chanwoo Choi <cw00.choi@samsung.com>
+Description:
+		The /sys/class/devfreq/.../name shows the name of device
+		of the corresponding devfreq object.
+
 What:		/sys/class/devfreq/.../governor
 Date:		September 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1259,6 +1259,14 @@ err_out:
 }
 EXPORT_SYMBOL(devfreq_remove_governor);
 
+static ssize_t name_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
+}
+static DEVICE_ATTR_RO(name);
+
 static ssize_t governor_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
@@ -1592,6 +1600,7 @@ static ssize_t trans_stat_show(struct de
 static DEVICE_ATTR_RO(trans_stat);
 
 static struct attribute *devfreq_attrs[] = {
+	&dev_attr_name.attr,
 	&dev_attr_governor.attr,
 	&dev_attr_available_governors.attr,
 	&dev_attr_cur_freq.attr,


