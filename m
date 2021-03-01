Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AA832910F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhCAUSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241503AbhCAULF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:11:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108D2653BD;
        Mon,  1 Mar 2021 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621622;
        bh=GlxxVNP9rhEar+fi8jeExJM4gGoPJ386ybd4Nou0H4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7cYaCcmY07jnW4KzzQB3IrxKERjPGDkxZ5VSPAO2XDrlmv0w4Bj2fpA7uXJjowUs
         CFwAe9LcfQ17b2EStSLUzDg5/6N9gj7VKJL+i0PxAELkEwvKH3AJ22dH7oyT34tEU5
         HpyN2bWDdz9U0s49MK6zsAs1VAuzTPiOzSh6wIb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ec3b3128c576e109171d@syzkaller.appspotmail.com,
        James Reynolds <jr@memlen.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 583/775] media: mceusb: Fix potential out-of-bounds shift
Date:   Mon,  1 Mar 2021 17:12:31 +0100
Message-Id: <20210301161230.257458398@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Reynolds <jr@memlen.com>

commit 1b43bad31fb0e00f45baf5b05bd21eb8d8ce7f58 upstream.

When processing a MCE_RSP_GETPORTSTATUS command, the bit index to set in
ir->txports_cabled comes from response data, and isn't validated.

As ir->txports_cabled is a u8, nothing should be done if the bit index
is greater than 7.

Cc: stable@vger.kernel.org
Reported-by: syzbot+ec3b3128c576e109171d@syzkaller.appspotmail.com
Signed-off-by: James Reynolds <jr@memlen.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1169,7 +1169,7 @@ static void mceusb_handle_command(struct
 		switch (subcmd) {
 		/* the one and only 5-byte return value command */
 		case MCE_RSP_GETPORTSTATUS:
-			if (buf_in[5] == 0)
+			if (buf_in[5] == 0 && *hi < 8)
 				ir->txports_cabled |= 1 << *hi;
 			break;
 


