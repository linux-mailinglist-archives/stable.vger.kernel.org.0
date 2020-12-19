Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697CE2DEEEF
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgLSM44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgLSM44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:56:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+9be25235b7a69b24d117@syzkaller.appspotmail.com
Subject: [PATCH 5.10 04/16] USB: legotower: fix logical error in recent commit
Date:   Sat, 19 Dec 2020 13:57:11 +0100
Message-Id: <20201219125339.283055949@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
References: <20201219125339.066340030@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit b175d273d4e4100b66e68f0675fef7a3c07a7957 upstream.

Commit d9f0d82f06c6 ("USB: legousbtower: use usb_control_msg_recv()")
contained an elementary logical error.  The check of the return code
from the new usb_control_msg_recv() function was inverted.

Reported-and-tested-by: syzbot+9be25235b7a69b24d117@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201208163042.GD1298255@rowland.harvard.edu
Fixes: d9f0d82f06c6 ("USB: legousbtower: use usb_control_msg_recv()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -797,7 +797,7 @@ static int tower_probe(struct usb_interf
 				      &get_version_reply,
 				      sizeof(get_version_reply),
 				      1000, GFP_KERNEL);
-	if (!result) {
+	if (result) {
 		dev_err(idev, "get version request failed: %d\n", result);
 		retval = result;
 		goto error;


