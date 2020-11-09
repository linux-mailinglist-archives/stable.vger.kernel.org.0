Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5815C2ABCFE
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgKINmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbgKINBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12A721D40;
        Mon,  9 Nov 2020 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926861;
        bh=OS6LUVPUcsiZkv5ftojY040WMhDzeW4LUMXou0etAJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBiW6JudHwnkj2SMvjYlP0eiD30FQh95IsAkbA40s0ozUDgBSpMMTH03b0t6qTtRG
         b5bq1/dDc+WMKFPbw0BdSgwxGjT+tZam71KEfUKC9RNXKbhTTrZqFDhtcZevcse/sp
         Lg5oztN3PZVA2QtpAjgY1IPacC6QryLkC69CRiRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/117] USB: adutux: fix debugging
Date:   Mon,  9 Nov 2020 13:54:16 +0100
Message-Id: <20201109125027.078899511@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit c56150c1bc8da5524831b1dac2eec3c67b89f587 ]

Handling for removal of the controller was missing at one place.
Add it.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20200917112600.26508-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/adutux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 7fb0590187d40..a1bc516be154d 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -210,6 +210,7 @@ static void adu_interrupt_out_callback(struct urb *urb)
 
 	if (status != 0) {
 		if ((status != -ENOENT) &&
+		    (status != -ESHUTDOWN) &&
 		    (status != -ECONNRESET)) {
 			dev_dbg(&dev->udev->dev,
 				"%s :nonzero status received: %d\n", __func__,
-- 
2.27.0



