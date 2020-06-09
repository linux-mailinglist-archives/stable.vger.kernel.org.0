Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EDC1F43FA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgFIR7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733178AbgFIRzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:55:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C4FA20774;
        Tue,  9 Jun 2020 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725302;
        bh=TUchAfSP3c+TsOsIJC3hkMN+LDRDbG1kStznIlC4JxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nO8bvQytATd2QL9p9v02JQgY9Ci5VWjgjGgRn6HLjv7HG5sBz+dwTWpyr/abeSMHy
         zEFNhVUu0Zq7ObnzrxA1nQq513dA1xfkoXZHqkArcuP79Ffe4Pec66X8u7f38/gcEU
         gd9V/TYt2XiP0Ln+3Cet+NT6xzKuFR5GgbumuuaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.7 02/24] USB: serial: usb_wwan: do not resubmit rx urb on fatal errors
Date:   Tue,  9 Jun 2020 19:45:33 +0200
Message-Id: <20200609174149.488304314@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
References: <20200609174149.255223112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Liu <b-liu@ti.com>

commit 986c1748c84d7727defeaeca74a73b37f7d5cce1 upstream.

usb_wwan_indat_callback() shouldn't resubmit rx urb if the previous urb
status is a fatal error. Or the usb controller would keep processing the
new urbs then run into interrupt storm, and has no chance to recover.

Fixes: 6c1ee66a0b2b ("USB-Serial: Fix error handling of usb_wwan")
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb_wwan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -270,6 +270,10 @@ static void usb_wwan_indat_callback(stru
 	if (status) {
 		dev_dbg(dev, "%s: nonzero status: %d on endpoint %02x.\n",
 			__func__, status, endpoint);
+
+		/* don't resubmit on fatal errors */
+		if (status == -ESHUTDOWN || status == -ENOENT)
+			return;
 	} else {
 		if (urb->actual_length) {
 			tty_insert_flip_string(&port->port, data,


