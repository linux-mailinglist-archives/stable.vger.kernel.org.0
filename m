Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04634336C64
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 07:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCKGn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 01:43:28 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54241 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230290AbhCKGnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 01:43:05 -0500
X-UUID: 9775fa7397f5439dbf3453bf1e23d5cb-20210311
X-UUID: 9775fa7397f5439dbf3453bf1e23d5cb-20210311
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 543715440; Thu, 11 Mar 2021 14:42:53 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Mar 2021 14:42:51 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:51 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Jim Lin <jilin@nvidia.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH v4] usb: gadget: configfs: Fix KASAN use-after-free
Date:   Thu, 11 Mar 2021 14:42:41 +0800
Message-ID: <1615444961-13376-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1484647168-30135-1-git-send-email-jilin@nvidia.com>
References: <1484647168-30135-1-git-send-email-jilin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

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

Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
Changes in v3:
 - Change commit description
Changes in v4:
 - Fix build error and adapt patch to kernel-5.12-rc1.
   Replace definition "MAX_USB_STRING_WITH_NULL_LEN" with
   "USB_MAX_STRING_WITH_NULL_LEN".
 - Note: The patch v2 and v3 has been verified by
   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
   http://spinics.net/lists/kernel/msg3840792.html
   and
   Macpaul Lin <macpaul.lin@mediatek.com> on Android kernels.
   http://lkml.org/lkml/2020/6/11/8
 - The patch is suggested to be applied to LTS versions.

 drivers/usb/gadget/configfs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 0d56f33..15a607c 100644
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
@@ -106,12 +108,16 @@ static int usb_string_copy(const char *s, char **s_copy)
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
-- 
1.7.9.5

