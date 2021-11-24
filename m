Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ACD45C3CD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbhKXNmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352277AbhKXNkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F2D63241;
        Wed, 24 Nov 2021 12:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758652;
        bh=KTKNPK8DPeei4rVV00q0Pds4f+25TFbzPEnPkWrIyCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy/P6HlxthQ6WlZGOz2pYZt4yY1sSb1p3EwYSXTnODm89WPUwwE1cagyztfpSagdV
         jFJcIYw93Lq/MlNhOajqsRp5jgRC5ZMNU1b4+LlrYU4m3z6dZayOPQblZpw4JxR58I
         MX2U7ST4xL1uG41GAnTQnZ9hTH0Rr9Hu7EZ1A0xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.10 138/154] drm/udl: fix control-message timeout
Date:   Wed, 24 Nov 2021 12:58:54 +0100
Message-Id: <20211124115706.954233488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5591c8f79db1729d9c5ac7f5b4d3a5c26e262d93 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 5320918b9a87 ("drm/udl: initial UDL driver (v4)")
Cc: stable@vger.kernel.org      # 3.4
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025115353.5089-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/udl/udl_connector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -30,7 +30,7 @@ static int udl_get_edid_block(void *data
 		ret = usb_control_msg(udl->udev,
 				      usb_rcvctrlpipe(udl->udev, 0),
 					  (0x02), (0x80 | (0x02 << 5)), bval,
-					  0xA1, read_buff, 2, HZ);
+					  0xA1, read_buff, 2, 1000);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
 			kfree(read_buff);


