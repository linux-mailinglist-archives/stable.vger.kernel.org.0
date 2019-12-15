Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7E11F751
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfLOLGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:06:06 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60237 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfLOLGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:06:06 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 343EB669;
        Sun, 15 Dec 2019 06:06:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RAJDjF
        oMBS52CNAfxTmTd4A7B1PdE0VKBSCR5wm2Fxg=; b=aoDGZMD4/LnErXtltXj51V
        UXQ0FkDXAWLP2Q+m2kUPITeaV2n6yuH1Hwppepniujx8lWEsyXE58bsZhF2F5Z7e
        4GauAmLLUVSeNlvuVK7BSMACcLAFpPPqu/i+YHcCNrzQKj5Sc/3nDIhAwkgwuxM+
        WgNUO0e95F0lCDquYhxaVdZP+DwlYaMNHk5DKvuOtn84WdWQLkTXTypDR5aAKUkr
        6CN4pmL81f2h2N7bZA72klyVvJbJ9ABa1osP14CxH+0BVp/0ln+6PfZgafEcSC34
        HNVaWL/VqXZ+Jsrgf4YaFvQtuwduLSdDK9QRjyi7bYi9mJuTeLDEeYMWbgSY61oQ
        ==
X-ME-Sender: <xms:nBP2XRFQsIGvtUoJ5pTTecdeA7WxmXDiS2Zm8sJ-s_Naw1FE1MTFDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:nBP2Xbu6v8hkd-b5o3vXFOTj8ZtRx_gyKQpUdSdAEs5hWx5kBoGJAA>
    <xmx:nBP2XfmF7txG1CJGW_4Y6OqbyragLcVJx3I6LUyVZcxagIhXeeP2gg>
    <xmx:nBP2XcNSufFfZ305-XQqD78XleZdOgynrM3JCTjVQaoNXkNJlpOKKA>
    <xmx:nBP2XZVvrX7Wi7qeeqJwFHuV9OspcgLOFD-cZFXeIlESWM_HgGnoxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E24A88005A;
        Sun, 15 Dec 2019 06:06:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: typec: fix use after free in typec_register_port()" failed to apply to 4.19-stable tree
To:     wenyang@linux.alibaba.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:06:01 +0100
Message-ID: <157640796159177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c388abefda0d92355714010c0199055c57ab6c7 Mon Sep 17 00:00:00 2001
From: Wen Yang <wenyang@linux.alibaba.com>
Date: Tue, 26 Nov 2019 22:04:52 +0800
Subject: [PATCH] usb: typec: fix use after free in typec_register_port()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We can't use "port->sw" and/or "port->mux" after it has been freed.

Fixes: 23481121c81d ("usb: typec: class: Don't use port parent for getting mux handles")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: stable <stable@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191126140452.14048-1-wenyang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 7ece6ca6e690..91d62276b56f 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1612,14 +1612,16 @@ struct typec_port *typec_register_port(struct device *parent,
 
 	port->sw = typec_switch_get(&port->dev);
 	if (IS_ERR(port->sw)) {
+		ret = PTR_ERR(port->sw);
 		put_device(&port->dev);
-		return ERR_CAST(port->sw);
+		return ERR_PTR(ret);
 	}
 
 	port->mux = typec_mux_get(&port->dev, NULL);
 	if (IS_ERR(port->mux)) {
+		ret = PTR_ERR(port->mux);
 		put_device(&port->dev);
-		return ERR_CAST(port->mux);
+		return ERR_PTR(ret);
 	}
 
 	ret = device_add(&port->dev);

