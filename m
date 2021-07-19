Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345133CDC66
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhGSOwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343736AbhGSOsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2704D61355;
        Mon, 19 Jul 2021 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708280;
        bh=W6/seEQ/mmK4LdL/pqfbA97mfOAQ/d3/aYwthDbPhWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hq40Vrxb9KcqsoLaD6rwmtR95JNH1wYwTVEya1vsO49oUSQJklO+VH2uuXv8kCWvA
         SBWrAwBHKQLpW8yV0WDDqPU+T+J8wNoAJODz0wYM4Jx1+ZF/SQIbZkBu6p2OR6PKLX
         CaOf8NRV8A93+yh4OVOI4UTK+3n0oyuQwVETRSl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 249/315] s390/sclp_vt220: fix console name to match device
Date:   Mon, 19 Jul 2021 16:52:18 +0200
Message-Id: <20210719144951.615297241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit b7d91d230a119fdcc334d10c9889ce9c5e15118b ]

Console name reported in /proc/consoles:

  ttyS1                -W- (EC p  )    4:65

does not match the char device name:

  crw--w----    1 root     root        4,  65 May 17 12:18 /dev/ttysclp0

so debian-installer inside a QEMU s390x instance gets confused and fails
to start with the following error:

  steal-ctty: No such file or directory

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Link: https://lore.kernel.org/r/20210427194010.9330-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c       | 2 +-
 drivers/s390/char/sclp_vt220.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 42025e33a4e0..ceaee215e243 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -140,7 +140,7 @@ static void __init set_preferred_console(void)
 	else if (CONSOLE_IS_3270)
 		add_preferred_console("tty3270", 0, NULL);
 	else if (CONSOLE_IS_VT220)
-		add_preferred_console("ttyS", 1, NULL);
+		add_preferred_console("ttysclp", 0, NULL);
 	else if (CONSOLE_IS_HVC)
 		add_preferred_console("hvc", 0, NULL);
 }
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index e84395d71389..0b9a83d51e2b 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -35,8 +35,8 @@
 #define SCLP_VT220_MINOR		65
 #define SCLP_VT220_DRIVER_NAME		"sclp_vt220"
 #define SCLP_VT220_DEVICE_NAME		"ttysclp"
-#define SCLP_VT220_CONSOLE_NAME		"ttyS"
-#define SCLP_VT220_CONSOLE_INDEX	1	/* console=ttyS1 */
+#define SCLP_VT220_CONSOLE_NAME		"ttysclp"
+#define SCLP_VT220_CONSOLE_INDEX	0	/* console=ttysclp0 */
 
 /* Representation of a single write request */
 struct sclp_vt220_request {
-- 
2.30.2



