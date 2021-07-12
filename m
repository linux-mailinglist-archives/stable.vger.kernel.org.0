Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E433C50F7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbhGLHfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245159AbhGLHdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B4A61374;
        Mon, 12 Jul 2021 07:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075037;
        bh=mN06SF4VSjSXGXyu6dP0YwqQ3pJaEq3g/1y+qp+mK4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDrvLwRPF9fV55l8ONcRk9pcsbISsKXJIBbdLyXm1Eht1lcr8yaG5U4+iutB2+LPk
         QrpmuD5gNVNEjzRI+TIQK202RsX67ZwZeFVAUFd3QVVsa9dbrnGa7QFQP/etelwm72
         oq4Ri22qpQGjrZmZZ4gy6t2/DKucg8aLAbKGF6e8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Murray McAllister <murray.mcallister@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Larkin <avlarkin82@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.13 040/800] Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl
Date:   Mon, 12 Jul 2021 08:01:03 +0200
Message-Id: <20210712060918.969960895@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -499,7 +499,7 @@ static int joydev_handle_JSIOCSBTNMAP(st
 	memcpy(joydev->keypam, keypam, len);
 
 	for (i = 0; i < joydev->nkey; i++)
-		joydev->keymap[keypam[i] - BTN_MISC] = i;
+		joydev->keymap[joydev->keypam[i] - BTN_MISC] = i;
 
  out:
 	kfree(keypam);


