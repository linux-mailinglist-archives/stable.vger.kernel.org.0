Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6112F613F
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbhANMsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 07:48:19 -0500
Received: from www.linuxtv.org ([130.149.80.248]:45008 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbhANMsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 07:48:19 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l022L-00EilM-BU; Thu, 14 Jan 2021 12:47:37 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 14 Jan 2021 12:45:38 +0000
Subject: [git:media_tree/master] media: mceusb: Fix potential out-of-bounds shift
To:     linuxtv-commits@linuxtv.org
Cc:     James Reynolds <jr@memlen.com>, stable@vger.kernel.org,
        Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l022L-00EilM-BU@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: mceusb: Fix potential out-of-bounds shift
Author:  James Reynolds <jr@memlen.com>
Date:    Tue Dec 22 13:07:04 2020 +0100

When processing a MCE_RSP_GETPORTSTATUS command, the bit index to set in
ir->txports_cabled comes from response data, and isn't validated.

As ir->txports_cabled is a u8, nothing should be done if the bit index
is greater than 7.

Cc: stable@vger.kernel.org
Reported-by: syzbot+ec3b3128c576e109171d@syzkaller.appspotmail.com
Signed-off-by: James Reynolds <jr@memlen.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/mceusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f1dbd059ed08..c8d63673e131 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1169,7 +1169,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, u8 *buf_in)
 		switch (subcmd) {
 		/* the one and only 5-byte return value command */
 		case MCE_RSP_GETPORTSTATUS:
-			if (buf_in[5] == 0)
+			if (buf_in[5] == 0 && *hi < 8)
 				ir->txports_cabled |= 1 << *hi;
 			break;
 
