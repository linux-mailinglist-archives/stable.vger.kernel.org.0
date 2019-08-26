Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876C59CBE7
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfHZIxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:53:04 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45415 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfHZIxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:53:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 403FC361;
        Mon, 26 Aug 2019 04:53:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xCOCfh
        pXGex3Ywp4Rw7RaoIdUmq3DUM3V1M4YFXMPFg=; b=eJ2TcpoA8GH9tYJvErhSWO
        9QC/Kw2EB4LjGZQFXA7zx/kAK8f7ebp9cVyzaTtACC3d4ues9i5X5X9e7lYoTf/z
        dtsWzWCXIa5PR2r8GfRhPkA3Ifg+2MXrWpq5fW3UJ0ZL8Zb0yvcMtnMzmZejcjUh
        3yKJDOvl/f439KhdZdhiCukVOq1BDNiekWEgOhVbCzzRG0I2LIi/uoQ0HsQLvpLO
        1rTZZ52V8srPuNHFwzHgpVCwTTw4JV7U9aFj8wpxhv6M/s2EC31NzvWPtF9zL6Fl
        S+IrYZA2oATxQCX5lsm/HQOsV69UHPsnk+Lqz5RMsmOG6H3sJqo4i5kmVk/6NHlg
        ==
X-ME-Sender: <xms:7p1jXQ9vC5pXMMgXeUy_NZ7meFZkEv_7CPBhf_smwC2yPd1bJu8WaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekledrvddthedruddvkedrvdegieenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:7p1jXQMbcfidOOQexZy6b6A7x_XmBuPQFzhOzE579vQUH6tONoz7-A>
    <xmx:7p1jXcFI1XBGD3gGGCXKhkYzNNCMYgOFkGKowH1BAArtu9kZ8aG4uA>
    <xmx:7p1jXehpymmm7-bk3UwXfpA0cEQ90dg-yfRU6MOE1-MZSQlHkK7VlQ>
    <xmx:7p1jXQ44j7N9TqM8yTsCXNO2x2LFt4T61Ioq-5FVN3B3WKnr1TozTg>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF7C980061;
        Mon, 26 Aug 2019 04:53:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] platform/chrome: cros_ec_ishtp: fix crash during suspend" failed to apply to 5.2-stable tree
To:     hyungwoo.yang@intel.com, enric.balletbo@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 10:52:59 +0200
Message-ID: <156680957919680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9cdde85804833af77c6afbf7c53f0d959c42eb9f Mon Sep 17 00:00:00 2001
From: Hyungwoo Yang <hyungwoo.yang@intel.com>
Date: Wed, 29 May 2019 21:03:54 -0700
Subject: [PATCH] platform/chrome: cros_ec_ishtp: fix crash during suspend

Kernel crashes during suspend due to wrong conversion in
suspend and resume functions.

Use the proper helper to get ishtp_cl_device instance.

Cc: <stable@vger.kernel.org> # 5.2.x: b12bbdc5: HID: intel-ish-hid: fix wrong driver_data usage
Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

diff --git a/drivers/platform/chrome/cros_ec_ishtp.c b/drivers/platform/chrome/cros_ec_ishtp.c
index e504d255d5ce..430731cdf827 100644
--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -707,7 +707,7 @@ static int cros_ec_ishtp_reset(struct ishtp_cl_device *cl_device)
  */
 static int __maybe_unused cros_ec_ishtp_suspend(struct device *device)
 {
-	struct ishtp_cl_device *cl_device = dev_get_drvdata(device);
+	struct ishtp_cl_device *cl_device = ishtp_dev_to_cl_device(device);
 	struct ishtp_cl	*cros_ish_cl = ishtp_get_drvdata(cl_device);
 	struct ishtp_cl_data *client_data = ishtp_get_client_data(cros_ish_cl);
 
@@ -722,7 +722,7 @@ static int __maybe_unused cros_ec_ishtp_suspend(struct device *device)
  */
 static int __maybe_unused cros_ec_ishtp_resume(struct device *device)
 {
-	struct ishtp_cl_device *cl_device = dev_get_drvdata(device);
+	struct ishtp_cl_device *cl_device = ishtp_dev_to_cl_device(device);
 	struct ishtp_cl	*cros_ish_cl = ishtp_get_drvdata(cl_device);
 	struct ishtp_cl_data *client_data = ishtp_get_client_data(cros_ish_cl);
 

