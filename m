Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3D4395A8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhJYML6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231358AbhJYML4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4161960EBD;
        Mon, 25 Oct 2021 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163774;
        bh=oA1rXK3mOZ0tq5cb2BaPVapIai6qb8HrBsRqLCGUxlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBk+U5/SOIahD3GkaV0dISWBx/2Syk/e09s5gG3p1U9wH+3wW+LWgQVUx/tr4D6RH
         GRVThmDYtQZVebfeG3ufFVRlTQLDfX5/239ztq8pq3rwZyzCEmJt9Joo1dWtHqqMGg
         wwpADX7MXIWeMRWAa2BNzfTCw3xBd0tQ87brJxSgCcoTEHYB0lqzpk6mNVjT4nl5qU
         FQR18xVBmDJEp/c2QFcDUcYPOJVBCyY0pusO5zlVEG12u6D81XgflesTRPr2I9kJLC
         X1FhKyjHpYq2pc9U0DMvhwEO0tSRT6K4N3DyC9oRgiaMbK7q5HpUqbBeUY0fYi8ull
         DH1PbqMHRNRCw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meymz-0001f9-5E; Mon, 25 Oct 2021 14:09:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] staging: r8712u: fix control-message timeout
Date:   Mon, 25 Oct 2021 14:09:10 +0200
Message-Id: <20211025120910.6339-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025120910.6339-1-johan@kernel.org>
References: <20211025120910.6339-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable@vger.kernel.org      # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/rtl8712/usb_ops_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 655497cead12..f984a5ab2c6f 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -494,7 +494,7 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
 		memcpy(pIo_buf, pdata, len);
 	}
 	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
-				 pIo_buf, len, HZ / 2);
+				 pIo_buf, len, 500);
 	if (status > 0) {  /* Success this control transfer. */
 		if (requesttype == 0x01) {
 			/* For Control read transfer, we have to copy the read
-- 
2.32.0

