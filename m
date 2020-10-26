Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A6299FBF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410089AbgJZXx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410080AbgJZXx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D502921D41;
        Mon, 26 Oct 2020 23:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756406;
        bh=SeK5CVTW6eYkfAWLEimvt5WJvBNvy3G2Vk7/auIrGeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKr2sT4eTeCG3LdN5nurZP5/MIJTh5K0l3TqbtB26z64nHnUrEwucnzq+o4nLsrM5
         aBlviH02Jbo2imvriTa/5X73y4l0BPW24n+68Vv4w2ieY4YQjH6KDp7WD4l7TlnQAq
         X/1yn4Rz/dZ/9JAwUZmt+uv0GbqvZrvUIAfafBR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 065/132] USB: adutux: fix debugging
Date:   Mon, 26 Oct 2020 19:50:57 -0400
Message-Id: <20201026235205.1023962-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d8d157c4c271d..96495fcd952aa 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -209,6 +209,7 @@ static void adu_interrupt_out_callback(struct urb *urb)
 
 	if (status != 0) {
 		if ((status != -ENOENT) &&
+		    (status != -ESHUTDOWN) &&
 		    (status != -ECONNRESET)) {
 			dev_dbg(&dev->udev->dev,
 				"%s :nonzero status received: %d\n", __func__,
-- 
2.25.1

