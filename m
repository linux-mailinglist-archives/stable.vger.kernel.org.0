Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6899B95
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391880AbfHVRZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389976AbfHVRZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:49 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BFE023428;
        Thu, 22 Aug 2019 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494748;
        bh=MO3w8eOgsbjNExjFPHSc41pUyf7L1Ax8e6jm2SBydpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvPS86UFqC3d9mwIunY/tb2yVYWjgJa+W0oS6l+53NHdBQUkPErKqdiCx51gydr+W
         eGb8GENI7icvtpmXAIUtgUAw2kB+DCu//GUes3TUZrjH3yQBrXGZ4gNj5JWQieqHST
         8lIniaQFu0cKxU28lOURGn20mX/U8idXW3n5125A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Gottfried Haider <gottfried.haider@gmail.com>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH 4.19 08/85] Revert "pwm: Set class for exported channels in sysfs"
Date:   Thu, 22 Aug 2019 10:18:41 -0700
Message-Id: <20190822171731.369519312@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit c289d6625237aa785b484b4e94c23b3b91ea7e60 upstream.

This reverts commit 7e5d1fd75c3dde9fc10c4472b9368089d1b81d00 ("pwm: Set
class for exported channels in sysfs") as it causes regression with
multiple pwm chip[1], when exporting a pwm channel (echo X > export):

- ABI (Documentation/ABI/testing/sysfs-class-pwm) states pwmX should be
  created in /sys/class/pwm/pwmchipN/pwmX
- Reverted patch causes new entry to be also created directly in
  /sys/class/pwm/pwmX
- 1st time, exporting pwmX will create an entry in /sys/class/pwm/pwmX
- class attributes are added under pwmX folder, such as export, unexport
  npwm, symlinks. This is wrong as it belongs to pwmchipN. It may cause
  bad behavior and report wrong values.
- when another export happens on another pwmchip, it can't be created
  (e.g. -EEXIST). This is causing the issue with multiple pwmchip.

Example on stm32 (stm32429i-eval) platform:
$ ls /sys/class/pwm
pwmchip0 pwmchip4

$ cd /sys/class/pwm/pwmchip0/
$ echo 0 > export
$ ls /sys/class/pwm
pwm0 pwmchip0 pwmchip4

$ cd /sys/class/pwm/pwmchip4/
$ echo 0 > export
sysfs: cannot create duplicate filename '/class/pwm/pwm0'
...Exception stack follows...

This is also seen on other platform [2]

[1] https://lkml.org/lkml/2018/9/25/713
[2] https://lkml.org/lkml/2018/9/25/447

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Tested-by: Gottfried Haider <gottfried.haider@gmail.com>
Tested-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Cc: John Keeping <john@metanate.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/sysfs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -263,7 +263,6 @@ static int pwm_export_child(struct devic
 	export->pwm = pwm;
 	mutex_init(&export->lock);
 
-	export->child.class = parent->class;
 	export->child.release = pwm_export_release;
 	export->child.parent = parent;
 	export->child.devt = MKDEV(0, 0);


