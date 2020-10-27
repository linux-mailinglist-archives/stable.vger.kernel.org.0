Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4305C299E4F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409832AbgJ0ANz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439267AbgJ0ALi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2092F20791;
        Tue, 27 Oct 2020 00:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757497;
        bh=k8n5ntisjntHlYtx2uja7AvfiRsSlnAeNMkxb8Nd0l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgAokBSnCrLKcYsMxIhe99Ab/wTRWqQQv3N2qd/BOr/TpwB5irR3bXLi+cKyQuQ3s
         Avc6S2CEbm0k5Zi+kpU8XAG1rTpjbtyDVEC38XJUdQznqyw2ceeEFg+3CcqurLQGky
         6TQGXr5OXzjMGhQ+rz2dIHdwPN9la+ncg1hxtNS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/25] USB: adutux: fix debugging
Date:   Mon, 26 Oct 2020 20:11:09 -0400
Message-Id: <20201027001123.1027642-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
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
index ba5c0a4591ac9..012d97f9c30c7 100644
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
2.25.1

