Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5905547DEC7
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 06:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346459AbhLWFpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 00:45:45 -0500
Received: from mo-csw-fb1516.securemx.jp ([210.130.202.172]:56714 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346414AbhLWFpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 00:45:44 -0500
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 00:45:44 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1516) id 1BN5Qwwh005056; Thu, 23 Dec 2021 14:26:58 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 1BN5Qegk019675; Thu, 23 Dec 2021 14:26:40 +0900
X-Iguazu-Qid: 34trEBPRiv8S8h5yhV
X-Iguazu-QSIG: v=2; s=0; t=1640237200; q=34trEBPRiv8S8h5yhV; m=Pz+rVJY8GTSjyDmnakak40oK6XflF5WcMp1wRCh4j2E=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1512) id 1BN5QdHP005895
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 14:26:39 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 496E61000F0;
        Thu, 23 Dec 2021 14:26:39 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 1BN5QcsH031555;
        Thu, 23 Dec 2021 14:26:39 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH for 4.4.y] usb: gadget: configfs: Fix use-after-free issue with udc_name
Date:   Thu, 23 Dec 2021 14:26:26 +0900
X-TSB-HOP: ON
Message-Id: <20211223052626.1631331-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie Hung <eddie.hung@mediatek.com>

commit 64e6bbfff52db4bf6785fab9cffab850b2de6870 upstream.

There is a use-after-free issue, if access udc_name
in function gadget_dev_desc_UDC_store after another context
free udc_name in function unregister_gadget.

Context 1:
gadget_dev_desc_UDC_store()->unregister_gadget()->
free udc_name->set udc_name to NULL

Context 2:
gadget_dev_desc_UDC_show()-> access udc_name

Call trace:
dump_backtrace+0x0/0x340
show_stack+0x14/0x1c
dump_stack+0xe4/0x134
print_address_description+0x78/0x478
__kasan_report+0x270/0x2ec
kasan_report+0x10/0x18
__asan_report_load1_noabort+0x18/0x20
string+0xf4/0x138
vsnprintf+0x428/0x14d0
sprintf+0xe4/0x12c
gadget_dev_desc_UDC_show+0x54/0x64
configfs_read_file+0x210/0x3a0
__vfs_read+0xf0/0x49c
vfs_read+0x130/0x2b4
SyS_read+0x114/0x208
el0_svc_naked+0x34/0x38

Add mutex_lock to protect this kind of scenario.

Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1609239215-21819-1-git-send-email-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Reference: CVE-2021-39648]
[iwamatsu: struct usb_gadget_driver does not have udc_name variable.
           Change struct gadget_info's udc_name.]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/usb/gadget/configfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 0ef3f4e452428c..6e1172450c7345 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -241,7 +241,16 @@ static ssize_t gadget_dev_desc_bcdUSB_store(struct config_item *item,
 
 static ssize_t gadget_dev_desc_UDC_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%s\n", to_gadget_info(item)->udc_name ?: "");
+	struct gadget_info *gi = to_gadget_info(item);
+	char *udc_name;
+	int ret;
+
+	mutex_lock(&gi->lock);
+	udc_name = gi->udc_name;
+	ret = sprintf(page, "%s\n", udc_name ?: "");
+	mutex_unlock(&gi->lock);
+
+	return ret;
 }
 
 static int unregister_gadget(struct gadget_info *gi)
-- 
2.34.1


