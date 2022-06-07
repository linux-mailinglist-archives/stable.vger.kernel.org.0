Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662AC540CFB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353491AbiFGSmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353473AbiFGSlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43AD55484;
        Tue,  7 Jun 2022 10:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47633617B0;
        Tue,  7 Jun 2022 17:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469F3C34115;
        Tue,  7 Jun 2022 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624726;
        bh=rPBvgnCvPO1NeOvOJ7gzKr0pzqOpITX4+dk7Nn1SKeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFvDTBGHxGMQUiwSqTiHfAd7JhUWsMVij4Cn8BIewnx5k+D9RFAFiTMDeCftor6Mm
         Xk78EiHS6enVDUCXIMHQqJOwtyTE04yaQl0iyoaTtnZY+3N6v0P7N5x1Yf0VSXT7It
         aBABIb2fkfcJGVUn6Fr7uFL78hxYumUX0r//DMKS8SzcBmk3wiYNcuIXoLviwYKVh6
         c6TFIeG4y80WKg9XCy0PriMAFkZaTcSXZ4kmVKl5DENRbW7YcIO3/k2uPA3j7rjCW/
         ro0yAteqlgN4L8KBD/P1fngokrro2/OL8mOWgDEUSIN6RxkZnA67fRISkO8+eUfHcl
         RBhljy+dh/FeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, kuba@kernel.org,
        len.baker@gmx.com, paskripkin@gmail.com, wanngchenng@gmail.com,
        skumark1902@gmail.com, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 02/38] staging: rtl8712: fix a potential memory leak in r871xu_drv_init()
Date:   Tue,  7 Jun 2022 13:57:57 -0400
Message-Id: <20220607175835.480735-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2214aca09730..daa3180dfde3 100644
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
index fed96d4251bf..77f090bdd36e 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -266,6 +266,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 static void r8712_usb_dvobj_deinit(struct _adapter *padapter)
 {
+	r8712_free_io_queue(padapter);
 }
 
 void rtl871x_intf_stop(struct _adapter *padapter)
@@ -303,9 +304,6 @@ void r871x_dev_unload(struct _adapter *padapter)
 			rtl8712_hal_deinit(padapter);
 		}
 
-		/*s6.*/
-		if (padapter->dvobj_deinit)
-			padapter->dvobj_deinit(padapter);
 		padapter->bup = false;
 	}
 }
@@ -610,6 +608,8 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	/* Stop driver mlme relation timer */
 	r8712_stop_drv_timers(padapter);
 	r871x_dev_unload(padapter);
+	if (padapter->dvobj_deinit)
+		padapter->dvobj_deinit(padapter);
 	r8712_free_drv_sw(padapter);
 	free_netdev(pnetdev);
 
-- 
2.35.1

