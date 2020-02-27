Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7CB171DF7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgB0OYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388937AbgB0OND (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C1F246A0;
        Thu, 27 Feb 2020 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812783;
        bh=2+jM9YNIiWuPmivbAP1Hc0TYus1L8SKnHwDiqoDRqMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SG3V8kCN/y03l+cAqvoflzH86zan7QYu47Lo/koYsErx+ciuUlpFJYWVINF+Vzps
         MR9WVA8nMTSCanOnlC84cvCRwIrxyn2os/mWTDrISB/z+Zg/ujtXd55BQfiaDOUdiN
         lQHqgkpeTYhPXi/sgn/ZWBngqgy8jIlsC+6SEwlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 5.5 015/150] ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()
Date:   Thu, 27 Feb 2020 14:35:52 +0100
Message-Id: <20200227132234.907705858@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit b4a81b87a4cfe2bb26a4a943b748d96a43ef20e8 upstream.

In ecryptfs_init_messaging(), if the allocation for 'ecryptfs_msg_ctx_arr'
fails, the previously allocated 'ecryptfs_daemon_hash' is not deallocated,
leading to a memory leak bug. To fix this issue, free
'ecryptfs_daemon_hash' before returning the error.

Cc: stable@vger.kernel.org
Fixes: 88b4a07e6610 ("[PATCH] eCryptfs: Public key transport mechanism")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/messaging.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -379,6 +379,7 @@ int __init ecryptfs_init_messaging(void)
 					* ecryptfs_message_buf_len),
 				       GFP_KERNEL);
 	if (!ecryptfs_msg_ctx_arr) {
+		kfree(ecryptfs_daemon_hash);
 		rc = -ENOMEM;
 		goto out;
 	}


