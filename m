Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240DF45BAB0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbhKXMOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242756AbhKXMLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F04E61155;
        Wed, 24 Nov 2021 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755580;
        bh=U6fr/6p0i58nGXzlBnCBSljN+xNFCGxcSrUA6tQfn0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtdtIUVKsr4oLOF94l48qLdHzQzpURXKVakY7lSYYpQkuC6qysfW0ws6kDwZI92MC
         8fPqqVJ2lxcHfgLTsyEu+aKdFPerSFhtzhHEVd8TSscT6c4u/CY+MslHdghOWlQnNi
         tLj0oBCrxa8VRI4qO45/l3Y5HhEVVE6fUyjSWSr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.4 147/162] drm/udl: fix control-message timeout
Date:   Wed, 24 Nov 2021 12:57:30 +0100
Message-Id: <20211124115703.029323350@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
@@ -37,7 +37,7 @@ static u8 *udl_get_edid(struct udl_devic
 		ret = usb_control_msg(udl->udev,
 				      usb_rcvctrlpipe(udl->udev, 0), (0x02),
 				      (0x80 | (0x02 << 5)), i << 8, 0xA1, rbuf, 2,
-				      HZ);
+				      1000);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
 			goto error;


