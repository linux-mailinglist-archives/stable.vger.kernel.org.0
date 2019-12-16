Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA0121529
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfLPSTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbfLPSTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988FD2166E;
        Mon, 16 Dec 2019 18:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520342;
        bh=Fn0AWLoRLFCe8iXoZK2bvmYmgoHgmT6Cz0yzfVVqEYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZMhoVrJ4QEVy37iB2xqdyVP3Dfg4nrPYHxcZ9lZmYgXfA5kqPY4/9mLGTVb5YTSN
         /yyTba8ZpTnVMilzabHwKuFvWnjTjIjNs+68wjQZJJ1+j5CfaImwmNFztscfOWnk5W
         LHmgVkpXI1rwEHbnTzM1mMeXQMdoZ7Uo0YYlIR20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 114/177] intel_th: Fix a double put_device() in error path
Date:   Mon, 16 Dec 2019 18:49:30 +0100
Message-Id: <20191216174842.471128434@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 512592779a337feb5905d8fcf9498dbf33672d4a upstream.

Commit a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
factored out intel_th_subdevice_alloc() from intel_th_populate(), but got
the error path wrong, resulting in two instances of a double put_device()
on a freshly initialized, but not 'added' device.

Fix this by only doing one put_device() in the error path.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
Reported-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
Link: https://lore.kernel.org/r/20191120130806.44028-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -649,10 +649,8 @@ intel_th_subdevice_alloc(struct intel_th
 	}
 
 	err = intel_th_device_add_resources(thdev, res, subdev->nres);
-	if (err) {
-		put_device(&thdev->dev);
+	if (err)
 		goto fail_put_device;
-	}
 
 	if (subdev->type == INTEL_TH_OUTPUT) {
 		if (subdev->mknode)
@@ -667,10 +665,8 @@ intel_th_subdevice_alloc(struct intel_th
 	}
 
 	err = device_add(&thdev->dev);
-	if (err) {
-		put_device(&thdev->dev);
+	if (err)
 		goto fail_free_res;
-	}
 
 	/* need switch driver to be loaded to enumerate the rest */
 	if (subdev->type == INTEL_TH_SWITCH && !req) {


