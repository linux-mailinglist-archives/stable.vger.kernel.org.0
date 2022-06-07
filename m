Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9547541743
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379420AbiFGVC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377001AbiFGU7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4699020B7FB;
        Tue,  7 Jun 2022 11:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CADB6160D;
        Tue,  7 Jun 2022 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50EFC385A2;
        Tue,  7 Jun 2022 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627494;
        bh=8Pa+ZWBuSKK55sy8yAH+Q70dUf42Cy8AMIJLEUeRCBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfDho5ES8WVVa/lIWxrUlLv6ikOcy3phttJVk/zIbGYTDjUwgjB5QpQZYsfxGkZhv
         iWHrwywsXhZsKf/4uyoPNcnzaIXvNnEzzqccrjZx5gJ3W95PvzPvxQjPEKV4kBp0zj
         wQoxgRD8s2EkhL3fCDS85OvyO6orZbO1Et+Xuf8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.17 760/772] staging: r8188eu: delete rtw_wx_read/write32()
Date:   Tue,  7 Jun 2022 19:05:52 +0200
Message-Id: <20220607165011.419067993@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4d0cc9e0e53e9946d7b8dc58279c62dfa7a2191b upstream.

These debugging tools let you call:

	status = usb_control_msg_recv/send(udev, 0, REALTEK_USB_VENQT_CMD_REQ,
				      REALTEK_USB_VENQT_READ/WRITE, value,
				      REALTEK_USB_VENQT_CMD_IDX, io_buf,
				      size, RTW_USB_CONTROL_MSG_TIMEOUT,
				      GFP_KERNEL);

with a user controlled "value" in the 0-0xffff range.  It's not a valid
API.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YoXS4OaD1oauPvmj@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c |   92 ---------------------------
 1 file changed, 2 insertions(+), 90 deletions(-)

--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1969,94 +1969,6 @@ static int rtw_wx_get_nick(struct net_de
 	return 0;
 }
 
-static int rtw_wx_read32(struct net_device *dev,
-			    struct iw_request_info *info,
-			    union iwreq_data *wrqu, char *extra)
-{
-	struct adapter *padapter;
-	struct iw_point *p;
-	u16 len;
-	u32 addr;
-	u32 data32;
-	u32 bytes;
-	u8 *ptmp;
-	int ret;
-
-	padapter = (struct adapter *)rtw_netdev_priv(dev);
-	p = &wrqu->data;
-	len = p->length;
-	ptmp = memdup_user(p->pointer, len);
-	if (IS_ERR(ptmp))
-		return PTR_ERR(ptmp);
-
-	bytes = 0;
-	addr = 0;
-	sscanf(ptmp, "%d,%x", &bytes, &addr);
-
-	switch (bytes) {
-	case 1:
-		data32 = rtw_read8(padapter, addr);
-		sprintf(extra, "0x%02X", data32);
-		break;
-	case 2:
-		data32 = rtw_read16(padapter, addr);
-		sprintf(extra, "0x%04X", data32);
-		break;
-	case 4:
-		data32 = rtw_read32(padapter, addr);
-		sprintf(extra, "0x%08X", data32);
-		break;
-	default:
-		DBG_88E(KERN_INFO "%s: usage> read [bytes],[address(hex)]\n", __func__);
-		ret = -EINVAL;
-		goto err_free_ptmp;
-	}
-	DBG_88E(KERN_INFO "%s: addr = 0x%08X data =%s\n", __func__, addr, extra);
-
-	kfree(ptmp);
-	return 0;
-
-err_free_ptmp:
-	kfree(ptmp);
-	return ret;
-}
-
-static int rtw_wx_write32(struct net_device *dev,
-			    struct iw_request_info *info,
-			    union iwreq_data *wrqu, char *extra)
-{
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
-	u32 addr;
-	u32 data32;
-	u32 bytes;
-
-	bytes = 0;
-	addr = 0;
-	data32 = 0;
-	sscanf(extra, "%d,%x,%x", &bytes, &addr, &data32);
-
-	switch (bytes) {
-	case 1:
-		rtw_write8(padapter, addr, (u8)data32);
-		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%02X\n", __func__, addr, (u8)data32);
-		break;
-	case 2:
-		rtw_write16(padapter, addr, (u16)data32);
-		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%04X\n", __func__, addr, (u16)data32);
-		break;
-	case 4:
-		rtw_write32(padapter, addr, data32);
-		DBG_88E(KERN_INFO "%s: addr = 0x%08X data = 0x%08X\n", __func__, addr, data32);
-		break;
-	default:
-		DBG_88E(KERN_INFO "%s: usage> write [bytes],[address(hex)],[data(hex)]\n", __func__);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int rtw_wx_read_rf(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
@@ -4267,8 +4179,8 @@ static const struct iw_priv_args rtw_pri
 };
 
 static iw_handler rtw_private_handler[] = {
-rtw_wx_write32,				/* 0x00 */
-rtw_wx_read32,				/* 0x01 */
+	NULL,				/* 0x00 */
+	NULL,				/* 0x01 */
 	NULL,				/* 0x02 */
 NULL,					/* 0x03 */
 /*  for MM DTV platform */


