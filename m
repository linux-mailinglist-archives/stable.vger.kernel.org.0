Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C423045C62C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347635AbhKXOFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356037AbhKXOD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D11716140B;
        Wed, 24 Nov 2021 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759451;
        bh=lwpk/FEiEM1kg8oWUH0Sgom34Xh3QaBeM8xtKvrzo+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKnZkb92PFuTR/iD7rB4jDSVxiTg5nsQUCZccF1Z1WaCiuWYWnpCDDdOICISMZbY7
         aFeuFWpCwtgSl7iNoQ/YzmpXveEu2D3XOMNCPBDZViQWKXYS1B1/XZl8PI+rKKqE/J
         68SW39Vzgw7jK7bEZ9XdmqOZYXUxaADhBT0Qg4Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.15 246/279] drm/udl: fix control-message timeout
Date:   Wed, 24 Nov 2021 12:58:53 +0100
Message-Id: <20211124115727.224831322@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
 		int bval = (i + block * EDID_LENGTH) << 8;
 		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      0x02, (0x80 | (0x02 << 5)), bval,
-				      0xA1, read_buff, 2, HZ);
+				      0xA1, read_buff, 2, 1000);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
 			kfree(read_buff);


