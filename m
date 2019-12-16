Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC01218E2
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLPRzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfLPRzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCA2206B7;
        Mon, 16 Dec 2019 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518935;
        bh=TxFF3dCzgNZSD/LydwsZgVZni2PRmnqkI8Is8MlGsmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4JXiovsO11CaPoT1jTfKYejDclMWC83rFjCseVuQxOQygn5DSkKgJzCjzl/yIpPx
         FkVuHI+AeP38LwscVuzQKrsU6/08HmtWNNpBi7ipkvJqWoJAnGYLVt3BYFAuu2a4f4
         aSVgDWUDLsz+p8niULQZDE2GO6qCT8W8MNcqgLKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 127/267] Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash
Date:   Mon, 16 Dec 2019 18:47:33 +0100
Message-Id: <20191216174904.447628873@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 86bcd3a12999447faad60ec59c2d64d18d8e61ac upstream.

F34 is a bit special as it reinitializes the device and related driver
structs during the firmware update. This clears the fn_irq_mask which
will then prevent F34 from receiving further interrupts, leading to
timeouts during the firmware update. Make sure to reinitialize the
IRQ enables at the appropriate times.

The issue is in F34 code, but the commit in the fixes tag exposed the
issue, as before this commit things would work by accident.

Fixes: 363c53875aef (Input: synaptics-rmi4 - avoid processing unknown IRQs)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20191129133514.23224-1-l.stach@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f34v7.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/rmi4/rmi_f34v7.c
+++ b/drivers/input/rmi4/rmi_f34v7.c
@@ -1192,6 +1192,9 @@ int rmi_f34v7_do_reflash(struct f34_data
 {
 	int ret;
 
+	f34->fn->rmi_dev->driver->set_irq_bits(f34->fn->rmi_dev,
+					       f34->fn->irq_mask);
+
 	rmi_f34v7_read_queries_bl_version(f34);
 
 	f34->v7.image = fw->data;


