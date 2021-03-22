Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E083443BC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCVMxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhCVMvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 635B0619A1;
        Mon, 22 Mar 2021 12:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417175;
        bh=oonXIXs0/g2VhSESrP3W/x2+6zA2q2vtqxWCGuRafpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpIKL4BFwfWczgkgq+I5NAMIZQljVLOZTv/RflZHO6WckpaauRIypq34ZkVVJL3li
         LLckYvckvwsO5LxLIOlEAg6MOigIsresAtUo1uFfZ9Oo4orony2XHv3OWKFYmSzlN9
         4lf0mQyg13H1IsaqZosdFgOFYgvsfjSTnNaqX9ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 4.4 04/14] platform/chrome: cros_ec_dev - Fix security issue
Date:   Mon, 22 Mar 2021 13:28:58 +0100
Message-Id: <20210322121919.341638975@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
References: <20210322121919.202392464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.

Prevent memory scribble by checking that ioctl buffer size parameters
are sane.
Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
.outsize the amount to scribble, we would overflow, allocate a small
amounts and be able to write outside of the malloc'ed area.
Adding a hard limit allows argument checking of the ioctl. With the
current EC, it is expected .insize and .outsize to be at around 512 bytes
or less.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_dev.c   |    4 ++++
 drivers/platform/chrome/cros_ec_proto.c |    4 ++--
 include/linux/mfd/cros_ec.h             |    6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct
 	if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
 		return -EFAULT;
 
+	if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
+	    (u_cmd.insize > EC_MAX_MSG_BYTES))
+		return -EINVAL;
+
 	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_dev
 			ec_dev->max_response = EC_PROTO2_MAX_PARAM_SIZE;
 			ec_dev->max_passthru = 0;
 			ec_dev->pkt_xfer = NULL;
-			ec_dev->din_size = EC_MSG_BYTES;
-			ec_dev->dout_size = EC_MSG_BYTES;
+			ec_dev->din_size = EC_PROTO2_MSG_BYTES;
+			ec_dev->dout_size = EC_PROTO2_MSG_BYTES;
 		} else {
 			/*
 			 * It's possible for a test to occur too early when
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -50,9 +50,11 @@ enum {
 					EC_MSG_TX_TRAILER_BYTES,
 	EC_MSG_RX_PROTO_BYTES	= 3,
 
-	/* Max length of messages */
-	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
+	/* Max length of messages for proto 2*/
+	EC_PROTO2_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
 					EC_MSG_TX_PROTO_BYTES,
+
+	EC_MAX_MSG_BYTES		= 64 * 1024,
 };
 
 /*


