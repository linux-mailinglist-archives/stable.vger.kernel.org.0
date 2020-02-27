Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B003171EEB
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgB0ODZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgB0ODY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:03:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41950246B7;
        Thu, 27 Feb 2020 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812203;
        bh=wYM9V+zsA6wV02SA+dp3+ev3gngYIW00NpH86KDIBTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nA5dLnJMvmv/TiZZnhbNgbDUoo7HfpRz2ts+lHRiJD1BSV1LH+PxDcqYdtRmT4Vo8
         9zlTdasy27xN7p7U8/IUSAtauSYt2bzyTStGHHU1mf54cnJqAlOI0dBphVO4Gytl8/
         QbWLDR5K4tnzxvG2vKKCQANJBMQ9SRLLVDU2bXO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 08/97] thunderbolt: Prevent crash if non-active NVMem file is read
Date:   Thu, 27 Feb 2020 14:36:16 +0100
Message-Id: <20200227132215.936905449@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
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
@@ -264,6 +264,12 @@ static int tb_switch_nvm_read(void *priv
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
@@ -309,6 +315,7 @@ static struct nvmem_device *register_nvm
 		config.read_only = true;
 	} else {
 		config.name = "nvm_non_active";
+		config.reg_read = tb_switch_nvm_no_read;
 		config.reg_write = tb_switch_nvm_write;
 		config.root_only = true;
 	}


