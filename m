Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A53353F3D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhDEJKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239424AbhDEJKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB4F613A1;
        Mon,  5 Apr 2021 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613838;
        bh=a5TpbOu3deqG8vgSiZmJu1Ki64q2WAiI1Rz2WzloT2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMXIJbbe+61xcWL4gDUejwCtBYCkCPdU06NDn1iEc9pUdJAgQ5cHN65WV5JWmO7ZN
         jeCO0/Lm9Bq6Zci2iXh7stAZXvoKoUtBZ1Hfkw4w6uo4QuxCksImszXVTfk35rdcRD
         +HTMp0bcD9/AO4Uc+m0txI6nbLnygq8Rg0TcZ408=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 109/126] cdc-acm: fix BREAK rx code path adding necessary calls
Date:   Mon,  5 Apr 2021 10:54:31 +0200
Message-Id: <20210405085034.646778138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 08dff274edda54310d6f1cf27b62fddf0f8d146e upstream.

Counting break events is nice but we should actually report them to
the tty layer.

Fixes: 5a6a62bdb9257 ("cdc-acm: add TIOCMIWAIT")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210311133714.31881-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -313,8 +313,10 @@ static void acm_process_notification(str
 			acm->iocount.dsr++;
 		if (difference & ACM_CTRL_DCD)
 			acm->iocount.dcd++;
-		if (newctrl & ACM_CTRL_BRK)
+		if (newctrl & ACM_CTRL_BRK) {
 			acm->iocount.brk++;
+			tty_insert_flip_char(&acm->port, 0, TTY_BREAK);
+		}
 		if (newctrl & ACM_CTRL_RI)
 			acm->iocount.rng++;
 		if (newctrl & ACM_CTRL_FRAMING)


