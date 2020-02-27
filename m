Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7889171BEF
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbgB0OHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:07:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388010AbgB0OHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:07:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EBE621D7E;
        Thu, 27 Feb 2020 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812420;
        bh=jTvwhF4KjEeGmTKvwo1HGhYhl0LBnNBc2sIqXvNxEEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNqkjCHOb8pGvVSaAA1qdz1wQ3FXKX71mfgix0HnTUHW6SZ3QrZf1kz1GJt2/U/FQ
         zhOveru1ETpzmVeGugYkomH0aYDvBKYX9PnYZQMv8mn1iQL3egRgav/SGbu1obcq6e
         Mju7QbvWZJskooLltXj8DtjRuNMTXqZJVfqr68l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.4 011/135] thunderbolt: Prevent crash if non-active NVMem file is read
Date:   Thu, 27 Feb 2020 14:35:51 +0100
Message-Id: <20200227132230.736007053@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 03cd45d2e219301880cabc357e3cf478a500080f upstream.

The driver does not populate .reg_read callback for the non-active NVMem
because the file is supposed to be write-only. However, it turns out
NVMem subsystem does not yet support this and expects that the .reg_read
callback is provided. If user reads the binary attribute it triggers
NULL pointer dereference like this one:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  Call Trace:
   bin_attr_nvmem_read+0x64/0x80
   kernfs_fop_read+0xa7/0x180
   vfs_read+0xbd/0x170
   ksys_read+0x5a/0xd0
   do_syscall_64+0x43/0x150
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this in the driver by providing .reg_read callback that always
returns an error.

Reported-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Fixes: e6b245ccd524 ("thunderbolt: Add support for host and device NVM firmware upgrade")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200213095604.1074-1-mika.westerberg@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/switch.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -274,6 +274,12 @@ out:
 	return ret;
 }
 
+static int tb_switch_nvm_no_read(void *priv, unsigned int offset, void *val,
+				 size_t bytes)
+{
+	return -EPERM;
+}
+
 static int tb_switch_nvm_write(void *priv, unsigned int offset, void *val,
 			       size_t bytes)
 {
@@ -319,6 +325,7 @@ static struct nvmem_device *register_nvm
 		config.read_only = true;
 	} else {
 		config.name = "nvm_non_active";
+		config.reg_read = tb_switch_nvm_no_read;
 		config.reg_write = tb_switch_nvm_write;
 		config.root_only = true;
 	}


