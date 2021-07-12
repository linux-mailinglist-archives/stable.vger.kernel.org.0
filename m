Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50F3C443C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhGLGR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhGLGR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19CFF610A6;
        Mon, 12 Jul 2021 06:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070508;
        bh=ttr+Sm68czz0/JvBfvQiQw5mAxOuyMTBI11fKSVVwxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKJNioh1LvhHSERvplPNTpAHCSStSJe6yLc2NYDYqIywDWyFt8tZoMlnPGEE/i5Ua
         tXIYN3Tyml4yWNInWpg1+S110ll2Y1qd/ValPBYT+2oaibSrXRmr84XiDCxBmWr9HR
         0srqflecad3VYqS6Y7ux278HQ7SleBqhQ6qAjwjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Murray McAllister <murray.mcallister@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Larkin <avlarkin82@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 020/348] Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl
Date:   Mon, 12 Jul 2021 08:06:44 +0200
Message-Id: <20210712060702.932807585@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Larkin <avlarkin82@gmail.com>

commit f8f84af5da9ee04ef1d271528656dac42a090d00 upstream.

Even though we validate user-provided inputs we then traverse past
validated data when applying the new map. The issue was originally
discovered by Murray McAllister with this simple POC (if the following
is executed by an unprivileged user it will instantly panic the system):

int main(void) {
	int fd, ret;
	unsigned int buffer[10000];

	fd = open("/dev/input/js0", O_RDONLY);
	if (fd == -1)
		printf("Error opening file\n");

	ret = ioctl(fd, JSIOCSBTNMAP & ~IOCSIZE_MASK, &buffer);
	printf("%d\n", ret);
}

The solution is to traverse internal buffer which is guaranteed to only
contain valid date when constructing the map.

Fixes: 182d679b2298 ("Input: joydev - prevent potential read overflow in ioctl")
Fixes: 999b874f4aa3 ("Input: joydev - validate axis/button maps before clobbering current ones")
Reported-by: Murray McAllister <murray.mcallister@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Alexander Larkin <avlarkin82@gmail.com>
Link: https://lore.kernel.org/r/20210620120030.1513655-1-avlarkin82@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joydev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -500,7 +500,7 @@ static int joydev_handle_JSIOCSBTNMAP(st
 	memcpy(joydev->keypam, keypam, len);
 
 	for (i = 0; i < joydev->nkey; i++)
-		joydev->keymap[keypam[i] - BTN_MISC] = i;
+		joydev->keymap[joydev->keypam[i] - BTN_MISC] = i;
 
  out:
 	kfree(keypam);


