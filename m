Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2063C3032
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhGJCdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhGJCbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A45A613F4;
        Sat, 10 Jul 2021 02:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884072;
        bh=hFLO14LY+2CjDGzsRluu6Qiid2+Ha5H969MvXV5KH/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbDuDPDXwpUiB6FXz5sQejFikG99hlAdiHBF5xFR8p0oQq4snlVlp3tFaKUZDSyVF
         TRd+JZXsPGRP+mn6AIV09jU/jcJH2ZO6knjYfBcl8vPhHDWSzXWFbeUd9hDfnyeEVa
         57w8ZSx83ye22i3BQu6fxzR2BsgzbQOoJ31A8VmTAnfBbfpt85hmwj8ol+5dqSuBIJ
         Nh/s3ucVY49fkuELa3F6AsROBM8rO1MXpakXOI+waJiWBERzU0PuD5OFELXQRNtcbv
         fwoGGd5faZvjPulYJK6Y2sOiSCd0HHPADgMO9CMf+lPa/Jt20ExReq7+yGmLAc7f+1
         lFxIlmzoquHUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/63] USB: core: Avoid WARNings for 0-length descriptor requests
Date:   Fri,  9 Jul 2021 22:26:39 -0400
Message-Id: <20210710022709.3170675-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 60dfe484cef45293e631b3a6e8995f1689818172 ]

The USB core has utility routines to retrieve various types of
descriptors.  These routines will now provoke a WARN if they are asked
to retrieve 0 bytes (USB "receive" requests must not have zero
length), so avert this by checking the size argument at the start.

CC: Johan Hovold <johan@kernel.org>
Reported-and-tested-by: syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210607152307.GD1768031@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/message.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 041c68ea329f..7ca908704777 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -647,6 +647,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	memset(buf, 0, size);	/* Make sure we parse really received data */
 
 	for (i = 0; i < 3; ++i) {
@@ -695,6 +698,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	for (i = 0; i < 3; ++i) {
 		/* retry on length 0 or stall; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-- 
2.30.2

