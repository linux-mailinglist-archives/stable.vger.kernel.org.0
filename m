Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728DEE4DD5
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395072AbfJYODA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502469AbfJYN53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E45421D82;
        Fri, 25 Oct 2019 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011848;
        bh=4QRjsrhYPA0imSh39a9J2RbDYp6757oYZBo2/ug4D1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEMRHVPVxfc+ZvJ6XS2+JhCKlchGScokp7mwNXbDjSLT3r4M2O7M37pA3TukqJYR1
         wfiv7PYW+7MynuZrK/vCF7uxfQ/QXLvfRaon2rbl59352U7mRblPMXk6p3a3Ber3HA
         fzJzcxwC8O/LBjoJMf2q+qMlo2My/EnmcpwtUL54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 08/25] powerpc/pseries/hvconsole: Fix stack overread via udbg
Date:   Fri, 25 Oct 2019 09:56:56 -0400
Message-Id: <20191025135715.25468-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 934bda59f286d0221f1a3ebab7f5156a996cc37d ]

While developing KASAN for 64-bit book3s, I hit the following stack
over-read.

It occurs because the hypercall to put characters onto the terminal
takes 2 longs (128 bits/16 bytes) of characters at a time, and so
hvc_put_chars() would unconditionally copy 16 bytes from the argument
buffer, regardless of supplied length. However, udbg_hvc_putc() can
call hvc_put_chars() with a single-byte buffer, leading to the error.

  ==================================================================
  BUG: KASAN: stack-out-of-bounds in hvc_put_chars+0xdc/0x110
  Read of size 8 at addr c0000000023e7a90 by task swapper/0

  CPU: 0 PID: 0 Comm: swapper Not tainted 5.2.0-rc2-next-20190528-02824-g048a6ab4835b #113
  Call Trace:
    dump_stack+0x104/0x154 (unreliable)
    print_address_description+0xa0/0x30c
    __kasan_report+0x20c/0x224
    kasan_report+0x18/0x30
    __asan_report_load8_noabort+0x24/0x40
    hvc_put_chars+0xdc/0x110
    hvterm_raw_put_chars+0x9c/0x110
    udbg_hvc_putc+0x154/0x200
    udbg_write+0xf0/0x240
    console_unlock+0x868/0xd30
    register_console+0x970/0xe90
    register_early_udbg_console+0xf8/0x114
    setup_arch+0x108/0x790
    start_kernel+0x104/0x784
    start_here_common+0x1c/0x534

  Memory state around the buggy address:
   c0000000023e7980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   c0000000023e7a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1
  >c0000000023e7a80: f1 f1 01 f2 f2 f2 00 00 00 00 00 00 00 00 00 00
                           ^
   c0000000023e7b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   c0000000023e7b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================

Document that a 16-byte buffer is requred, and provide it in udbg.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hvconsole.c |  2 +-
 drivers/tty/hvc/hvc_vio.c                  | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvconsole.c b/arch/powerpc/platforms/pseries/hvconsole.c
index 74da18de853af..73ec15cd27080 100644
--- a/arch/powerpc/platforms/pseries/hvconsole.c
+++ b/arch/powerpc/platforms/pseries/hvconsole.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL(hvc_get_chars);
  * @vtermno: The vtermno or unit_address of the adapter from which the data
  *	originated.
  * @buf: The character buffer that contains the character data to send to
- *	firmware.
+ *	firmware. Must be at least 16 bytes, even if count is less than 16.
  * @count: Send this number of characters.
  */
 int hvc_put_chars(uint32_t vtermno, const char *buf, int count)
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index a1d272ac82bb4..c33150fcd9642 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -120,6 +120,14 @@ static int hvterm_raw_get_chars(uint32_t vtermno, char *buf, int count)
 	return got;
 }
 
+/**
+ * hvterm_raw_put_chars: send characters to firmware for given vterm adapter
+ * @vtermno: The virtual terminal number.
+ * @buf: The characters to send. Because of the underlying hypercall in
+ *       hvc_put_chars(), this buffer must be at least 16 bytes long, even if
+ *       you are sending fewer chars.
+ * @count: number of chars to send.
+ */
 static int hvterm_raw_put_chars(uint32_t vtermno, const char *buf, int count)
 {
 	struct hvterm_priv *pv = hvterm_privs[vtermno];
@@ -232,6 +240,7 @@ static const struct hv_ops hvterm_hvsi_ops = {
 static void udbg_hvc_putc(char c)
 {
 	int count = -1;
+	unsigned char bounce_buffer[16];
 
 	if (!hvterm_privs[0])
 		return;
@@ -242,7 +251,12 @@ static void udbg_hvc_putc(char c)
 	do {
 		switch(hvterm_privs[0]->proto) {
 		case HV_PROTOCOL_RAW:
-			count = hvterm_raw_put_chars(0, &c, 1);
+			/*
+			 * hvterm_raw_put_chars requires at least a 16-byte
+			 * buffer, so go via the bounce buffer
+			 */
+			bounce_buffer[0] = c;
+			count = hvterm_raw_put_chars(0, bounce_buffer, 1);
 			break;
 		case HV_PROTOCOL_HVSI:
 			count = hvterm_hvsi_put_chars(0, &c, 1);
-- 
2.20.1

