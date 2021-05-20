Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D3738A818
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhETKq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238130AbhETKoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48D361C97;
        Thu, 20 May 2021 09:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504633;
        bh=dIQwHZRW1nuaV/U8JlEyKoa47ZeXRKYoOtsBAICauTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzjICuDDoXOC7Q7DJwIZ4RUKMCR2Ka1g9zFslP5harJVqlJr4nZr6/w+yDsrS5ZCv
         zAV4m0Mp+Q4WlMzPkmILjttkyRoFVdetiAqJpgA2OIx+zGXelZH40KVtMYJ87uL/Hl
         ZQqr8YoEA/n4wTqATy83WirFLdmRzz70+vnE2WWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 4.9 011/240] ecryptfs: fix kernel panic with null dev_name
Date:   Thu, 20 May 2021 11:20:03 +0200
Message-Id: <20210520092108.990086734@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -506,6 +506,12 @@ static struct dentry *ecryptfs_mount(str
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


