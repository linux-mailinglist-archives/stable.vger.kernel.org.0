Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D14378585
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhEJLAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234321AbhEJK4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0562C617ED;
        Mon, 10 May 2021 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643518;
        bh=SvxhWZ34ayENmMcCz/K3zPsrZ+A03KowhXP6NSbfnG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t+zI6WR44cWcxq2SflaMQOtRPGXRlgXCvnJhGEXC7GwOOI4RNKX5VKRiiQH2MOKw
         ukpfJsVDiG9CV5v0fav4f70kMeSVq8d5n+gFYjQ9mm5T8pJdzalBCYsXAlLO42BUZU
         UUcinEQYwqDrLe+4yue0kFn1fyTke25LpLJ4dAss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.11 020/342] ecryptfs: fix kernel panic with null dev_name
Date:   Mon, 10 May 2021 12:16:50 +0200
Message-Id: <20210510102010.777714351@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 9046625511ad8dfbc8c6c2de16b3532c43d68d48 upstream.

When mounting eCryptfs, a null "dev_name" argument to ecryptfs_mount()
causes a kernel panic if the parsed options are valid. The easiest way to
reproduce this is to call mount() from userspace with an existing
eCryptfs mount's options and a "source" argument of 0.

Error out if "dev_name" is null in ecryptfs_mount()

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -492,6 +492,12 @@ static struct dentry *ecryptfs_mount(str
 		goto out;
 	}
 
+	if (!dev_name) {
+		rc = -EINVAL;
+		err = "Device name cannot be null";
+		goto out;
+	}
+
 	rc = ecryptfs_parse_options(sbi, raw_data, &check_ruid);
 	if (rc) {
 		err = "Error parsing options";


