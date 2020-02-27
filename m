Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E62171B1A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgB0N7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732611AbgB0N7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C912084E;
        Thu, 27 Feb 2020 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811972;
        bh=pxjce3r46L/EQbcrQrcK0UOGjI+bXzSAe2pNJJEVYtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZ2gwio0SNzJkmZNZJUV0GdW8IAnpUJDv8qP7WBTV1rOWGiF4xx70neXaeXcpjqgJ
         O36RZB6q48uvuRE438w/OFxIJoCZ3ElYKr/cdmjwQPBJbwzrfkBR6e3NJxwd68WwGf
         P7mflFzLV+BOdyj4rIQ/bGEYSwLcCjq8O6DlWXTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.14 172/237] thunderbolt: Prevent crash if non-active NVMem file is read
Date:   Thu, 27 Feb 2020 14:36:26 +0100
Message-Id: <20200227132309.084489003@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
@@ -240,6 +240,12 @@ static int tb_switch_nvm_read(void *priv
 	return dma_port_flash_read(sw->dma_port, offset, val, bytes);
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
@@ -285,6 +291,7 @@ static struct nvmem_device *register_nvm
 		config.read_only = true;
 	} else {
 		config.name = "nvm_non_active";
+		config.reg_read = tb_switch_nvm_no_read;
 		config.reg_write = tb_switch_nvm_write;
 		config.root_only = true;
 	}


