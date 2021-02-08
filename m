Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F33137F9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhBHPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhBHPaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A8164ECF;
        Mon,  8 Feb 2021 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797419;
        bh=cs2i0zQJo6kJaYFXcsC58TeKtkSQPupNvIV5ikM+cRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy+Pr4+1NJsypMTZeaSV5IGj7mC0lyfiyMnHL/Yp8Qeqc3AuOjibf0gFfiRiX4MQ1
         YiDRFEZIrenPhBqptnMhWt3s+sDXMt+FVsS2vJOMIWOxnK7GBdXo8GqLm6Zl78KsJr
         v40PC8pNKj+X+GS2iZOH8MyCFiA+ALiWi3wYeySY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 096/120] ARM: footbridge: fix dc21285 PCI configuration accessors
Date:   Mon,  8 Feb 2021 16:01:23 +0100
Message-Id: <20210208145822.213842637@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 39d3454c3513840eb123b3913fda6903e45ce671 upstream.

Building with gcc 4.9.2 reveals a latent bug in the PCI accessors
for Footbridge platforms, which causes a fatal alignment fault
while accessing IO memory. Fix this by making the assembly volatile.

Cc: stable@vger.kernel.org
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-footbridge/dc21285.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -65,15 +65,15 @@ dc21285_read_config(struct pci_bus *bus,
 	if (addr)
 		switch (size) {
 		case 1:
-			asm("ldrb	%0, [%1, %2]"
+			asm volatile("ldrb	%0, [%1, %2]"
 				: "=r" (v) : "r" (addr), "r" (where) : "cc");
 			break;
 		case 2:
-			asm("ldrh	%0, [%1, %2]"
+			asm volatile("ldrh	%0, [%1, %2]"
 				: "=r" (v) : "r" (addr), "r" (where) : "cc");
 			break;
 		case 4:
-			asm("ldr	%0, [%1, %2]"
+			asm volatile("ldr	%0, [%1, %2]"
 				: "=r" (v) : "r" (addr), "r" (where) : "cc");
 			break;
 		}
@@ -99,17 +99,17 @@ dc21285_write_config(struct pci_bus *bus
 	if (addr)
 		switch (size) {
 		case 1:
-			asm("strb	%0, [%1, %2]"
+			asm volatile("strb	%0, [%1, %2]"
 				: : "r" (value), "r" (addr), "r" (where)
 				: "cc");
 			break;
 		case 2:
-			asm("strh	%0, [%1, %2]"
+			asm volatile("strh	%0, [%1, %2]"
 				: : "r" (value), "r" (addr), "r" (where)
 				: "cc");
 			break;
 		case 4:
-			asm("str	%0, [%1, %2]"
+			asm volatile("str	%0, [%1, %2]"
 				: : "r" (value), "r" (addr), "r" (where)
 				: "cc");
 			break;


