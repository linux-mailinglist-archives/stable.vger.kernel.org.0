Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6C26A71B
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgIOObd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbgIOOb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D959422BEF;
        Tue, 15 Sep 2020 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179788;
        bh=sqMiux7YFL12oeLmvSHQEdY+BOA8nNfOb2gJMb81Z9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klksSWbMZHmkhGoOYqvCpxH2sRRWHD0Kvce1+Gqwv2UTS92IZB6Z9Gu4Qx3cbp9NX
         z4+WvwFAvvxsIYMuCrZADZreWxXACIT2kwX4FAqCYtGFGDnP+yEN5vDD8a8nsaMiDE
         jrj+YaNsEZk/Yk2M1oPkbcuiLnUqCVq1j3+Z/nb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 5.4 118/132] debugfs: Fix module state check condition
Date:   Tue, 15 Sep 2020 16:13:40 +0200
Message-Id: <20200915140650.024329304@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

commit e3b9fc7eec55e6fdc8beeed18f2ed207086341e2 upstream.

The '#ifdef MODULE' check in the original commit does not work as intended.
The code under the check is not built at all if CONFIG_DEBUG_FS=y. Fix this
by using a correct check.

Fixes: 275678e7a9be ("debugfs: Check module state before warning in {full/open}_proxy_open()")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811150129.53343-1-vdronov@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/debugfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -176,7 +176,7 @@ static int open_proxy_open(struct inode
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;
@@ -311,7 +311,7 @@ static int full_proxy_open(struct inode
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;


