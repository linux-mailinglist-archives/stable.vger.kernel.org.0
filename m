Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C3438EEA1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhEXPwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233642AbhEXPuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BAA61627;
        Mon, 24 May 2021 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870710;
        bh=9J3fCZzdSY+SR9R8CzFmZdWGLQ8dBqCuYG2SLz4FRFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKN6ZPQe+do39Wrgky559jDdI4b4w/AOofhjFvy+M7SObWQx7JaO2y2eXTtbSBOka
         O0lS+FD7tgvD+VLixIrgvPTXbl/q9eFTJrBE+//bcHndD8K9MYiUeUBZW9698thQos
         jnG8oFNNb2QXpo0LZhNLx6vo9piEEDKQIGve2BTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 5.4 71/71] Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS
Date:   Mon, 24 May 2021 17:26:17 +0200
Message-Id: <20210524152328.751081397@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b86b0b150fed840c376145383ef5105116c81b0c upstream.

L2CAP_OPTIONS shall only be used with BR/EDR modes.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -426,6 +426,20 @@ static int l2cap_sock_getsockopt_old(str
 			break;
 		}
 
+		/* Only BR/EDR modes are supported here */
+		switch (chan->mode) {
+		case L2CAP_MODE_BASIC:
+		case L2CAP_MODE_ERTM:
+		case L2CAP_MODE_STREAMING:
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+
+		if (err < 0)
+			break;
+
 		memset(&opts, 0, sizeof(opts));
 		opts.imtu     = chan->imtu;
 		opts.omtu     = chan->omtu;
@@ -685,10 +699,8 @@ static int l2cap_sock_setsockopt_old(str
 			break;
 		}
 
-		chan->mode = opts.mode;
-		switch (chan->mode) {
-		case L2CAP_MODE_LE_FLOWCTL:
-			break;
+		/* Only BR/EDR modes are supported here */
+		switch (opts.mode) {
 		case L2CAP_MODE_BASIC:
 			clear_bit(CONF_STATE2_DEVICE, &chan->conf_state);
 			break;
@@ -702,6 +714,10 @@ static int l2cap_sock_setsockopt_old(str
 			break;
 		}
 
+		if (err < 0)
+			break;
+
+		chan->mode = opts.mode;
 		chan->imtu = opts.imtu;
 		chan->omtu = opts.omtu;
 		chan->fcs  = opts.fcs;


