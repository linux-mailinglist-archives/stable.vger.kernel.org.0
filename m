Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88E7344170
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhCVMde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhCVMcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DE26199E;
        Mon, 22 Mar 2021 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416366;
        bh=m0x2fiiWRpm+GbCOB1gUeQYkZ1jaK5WjwHb/FPiolgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wo2jhq1qg3M/JGBWDg69Q+sNylh9/TTmAlLx9NP0IAW7kxmQX3LY2e8PG8Mx07SFr
         E68IiZ50ujE6ZVlio2NusM8MzY+6xZ5JAv+I51maXBXUi6/50CMDjmwdCdySxAAWQo
         FGZPO2mPsFE0jUJVhDzxC/9iEyfEbA5P0SYli9ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Lin <jilin@nvidia.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 5.11 080/120] usb: gadget: configfs: Fix KASAN use-after-free
Date:   Mon, 22 Mar 2021 13:27:43 +0100
Message-Id: <20210322121932.338646904@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

commit 98f153a10da403ddd5e9d98a3c8c2bb54bb5a0b6 upstream.

When gadget is disconnected, running sequence is like this.
. composite_disconnect
. Call trace:
  usb_string_copy+0xd0/0x128
  gadget_config_name_configuration_store+0x4
  gadget_config_name_attr_store+0x40/0x50
  configfs_write_file+0x198/0x1f4
  vfs_write+0x100/0x220
  SyS_write+0x58/0xa8
. configfs_composite_unbind
. configfs_composite_bind

In configfs_composite_bind, it has
"cn->strings.s = cn->configuration;"

When usb_string_copy is invoked. it would
allocate memory, copy input string, release previous pointed memory space,
and use new allocated memory.

When gadget is connected, host sends down request to get information.
Call trace:
  usb_gadget_get_string+0xec/0x168
  lookup_string+0x64/0x98
  composite_setup+0xa34/0x1ee8

If gadget is disconnected and connected quickly, in the failed case,
cn->configuration memory has been released by usb_string_copy kfree but
configfs_composite_bind hasn't been run in time to assign new allocated
"cn->configuration" pointer to "cn->strings.s".

When "strlen(s->s) of usb_gadget_get_string is being executed, the dangling
memory is accessed, "BUG: KASAN: use-after-free" error occurs.

Cc: stable@vger.kernel.org
Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/1615444961-13376-1-git-send-email-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -97,6 +97,8 @@ struct gadget_config_name {
 	struct list_head list;
 };
 
+#define USB_MAX_STRING_WITH_NULL_LEN	(USB_MAX_STRING_LEN+1)
+
 static int usb_string_copy(const char *s, char **s_copy)
 {
 	int ret;
@@ -106,12 +108,16 @@ static int usb_string_copy(const char *s
 	if (ret > USB_MAX_STRING_LEN)
 		return -EOVERFLOW;
 
-	str = kstrdup(s, GFP_KERNEL);
-	if (!str)
-		return -ENOMEM;
+	if (copy) {
+		str = copy;
+	} else {
+		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		if (!str)
+			return -ENOMEM;
+	}
+	strcpy(str, s);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
-	kfree(copy);
 	*s_copy = str;
 	return 0;
 }


