Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4217F549126
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359565AbiFMNNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359475AbiFMNJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:09:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC3639B98;
        Mon, 13 Jun 2022 04:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7877CB80D31;
        Mon, 13 Jun 2022 11:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD02C34114;
        Mon, 13 Jun 2022 11:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119248;
        bh=IQLEsmrKiVuGX+dVFlCbbaUWubNS1XxR6sRXnYMgr/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDlQjPZya0tbb2vGzG2BD1avGXDy2QKelW9SvElUuC8V12ix+LsOw/CLAHEZ2Jfjq
         WDKsk3l+a0XNUYFEjqstyY6Jz3vY80/PaXNhcblE9P9R6ZpG8Yt7obtN2+BmIgO2vv
         TquWVOy9IIRACgg7qgbYngBnERtsVWrkjvHM350g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/247] staging: rtl8712: fix a potential memory leak in r871xu_drv_init()
Date:   Mon, 13 Jun 2022 12:11:08 +0200
Message-Id: <20220613094927.993699724@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 7288ff561de650d4139fab80e9cb0da9b5b32434 ]

In r871xu_drv_init(), if r8712_init_drv_sw() fails, then the memory
allocated by r8712_alloc_io_queue() in r8712_usb_dvobj_init() is not
properly released as there is no action will be performed by
r8712_usb_dvobj_deinit().
To properly release it, we should call r8712_free_io_queue() in
r8712_usb_dvobj_deinit().

Besides, in r871xu_dev_remove(), r8712_usb_dvobj_deinit() will be called
by r871x_dev_unload() under condition `padapter->bup` and
r8712_free_io_queue() is called by r8712_free_drv_sw().
However, r8712_usb_dvobj_deinit() does not rely on `padapter->bup` and
calling r8712_free_io_queue() in r8712_free_drv_sw() is negative for
better understading the code.
So I move r8712_usb_dvobj_deinit() into r871xu_dev_remove(), and remove
r8712_free_io_queue() from r8712_free_drv_sw().

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Link: https://lore.kernel.org/r/tencent_B8048C592777830380A23A7C4409F9DF1305@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/os_intfs.c | 1 -
 drivers/staging/rtl8712/usb_intf.c | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 9502f6aa5306..bc033849fcea 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -332,7 +332,6 @@ void r8712_free_drv_sw(struct _adapter *padapter)
 	r8712_free_evt_priv(&padapter->evtpriv);
 	r8712_DeInitSwLeds(padapter);
 	r8712_free_mlme_priv(&padapter->mlmepriv);
-	r8712_free_io_queue(padapter);
 	_free_xmit_priv(&padapter->xmitpriv);
 	_r8712_free_sta_priv(&padapter->stapriv);
 	_r8712_free_recv_priv(&padapter->recvpriv);
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index cae04272deff..a61dd96ab2a4 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -265,6 +265,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 static void r8712_usb_dvobj_deinit(struct _adapter *padapter)
 {
+	r8712_free_io_queue(padapter);
 }
 
 void rtl871x_intf_stop(struct _adapter *padapter)
@@ -302,9 +303,6 @@ void r871x_dev_unload(struct _adapter *padapter)
 			rtl8712_hal_deinit(padapter);
 		}
 
-		/*s6.*/
-		if (padapter->dvobj_deinit)
-			padapter->dvobj_deinit(padapter);
 		padapter->bup = false;
 	}
 }
@@ -607,6 +605,8 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	/* Stop driver mlme relation timer */
 	r8712_stop_drv_timers(padapter);
 	r871x_dev_unload(padapter);
+	if (padapter->dvobj_deinit)
+		padapter->dvobj_deinit(padapter);
 	r8712_free_drv_sw(padapter);
 	free_netdev(pnetdev);
 
-- 
2.35.1



