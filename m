Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4E304B30
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbhAZEtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbhAYSqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4E952075B;
        Mon, 25 Jan 2021 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600320;
        bh=lej7wnmiUtQtlE1WgTEjkg07smA7m24/nuwPXk4qCEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFLIY6y7XwTxrLtwcJ3dXNgw5qQbxvdqhIwXq+FD7rRguWZFi+gmBsK19DW/2TNQW
         vhLR21DVFk0s6U6QjPrJioJ//4iK5t1OXgEKnt22TwN+pQthEnvLmv35BTQ/9IzqCc
         ZUKWTXFPZQ6RZ7xlZ0lcxMa8FR+KlqZJMjbdyMw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hui <john.wanghui@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.4 57/86] stm class: Fix module init return on allocation failure
Date:   Mon, 25 Jan 2021 19:39:39 +0100
Message-Id: <20210125183203.460005989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hui <john.wanghui@huawei.com>

commit 927633a6d20af319d986f3e42c3ef9f6d7835008 upstream.

In stm_heartbeat_init(): return value gets reset after the first
iteration by stm_source_register_device(), so allocation failures
after that will, after a clean up, return success. Fix that.

Fixes: 119291853038 ("stm class: Add heartbeat stm source device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hui <john.wanghui@huawei.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20210115195917.3184-2-alexander.shishkin@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/stm/heartbeat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hwtracing/stm/heartbeat.c
+++ b/drivers/hwtracing/stm/heartbeat.c
@@ -64,7 +64,7 @@ static void stm_heartbeat_unlink(struct
 
 static int stm_heartbeat_init(void)
 {
-	int i, ret = -ENOMEM;
+	int i, ret;
 
 	if (nr_devs < 0 || nr_devs > STM_HEARTBEAT_MAX)
 		return -EINVAL;
@@ -72,8 +72,10 @@ static int stm_heartbeat_init(void)
 	for (i = 0; i < nr_devs; i++) {
 		stm_heartbeat[i].data.name =
 			kasprintf(GFP_KERNEL, "heartbeat.%d", i);
-		if (!stm_heartbeat[i].data.name)
+		if (!stm_heartbeat[i].data.name) {
+			ret = -ENOMEM;
 			goto fail_unregister;
+		}
 
 		stm_heartbeat[i].data.nr_chans	= 1;
 		stm_heartbeat[i].data.link	= stm_heartbeat_link;


