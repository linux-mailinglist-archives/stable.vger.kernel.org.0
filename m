Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95C61F3FC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfEOMRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbfEOLCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9465120881;
        Wed, 15 May 2019 11:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918129;
        bh=J2mkD67Lx8vV4ZreU/vwMWvsFmukwVU2kJoI6FxqH/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxDENtXt1m3mXm7Xcac5V6slU5Te/N2XKbP0lp/LuqgE9UcTHwXhTytq6cTxTwf/U
         BC8wX7Ym0EVVBiOodIreUHpI+Bw73hmRvN7Lpl9d5qn0Bzo6kZDBr8EEn9te8zTQYK
         D9Dptyt8PHukdRps0+66m3+zeTbYcEORAEv/923M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 4.4 017/266] powerpc/rfi-flush: Move the logic to avoid a redo into the debugfs code
Date:   Wed, 15 May 2019 12:52:04 +0200
Message-Id: <20190515090723.199639524@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 1e2a9fc7496955faacbbed49461d611b704a7505 upstream.

rfi_flush_enable() includes a check to see if we're already
enabled (or disabled), and in that case does nothing.

But that means calling setup_rfi_flush() a 2nd time doesn't actually
work, which is a bit confusing.

Move that check into the debugfs code, where it really belongs.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_64.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -873,9 +873,6 @@ static void do_nothing(void *unused)
 
 void rfi_flush_enable(bool enable)
 {
-	if (rfi_flush == enable)
-		return;
-
 	if (enable) {
 		do_rfi_flush_fixups(enabled_flush_types);
 		on_each_cpu(do_nothing, NULL, 1);
@@ -929,13 +926,19 @@ void __init setup_rfi_flush(enum l1d_flu
 #ifdef CONFIG_DEBUG_FS
 static int rfi_flush_set(void *data, u64 val)
 {
+	bool enable;
+
 	if (val == 1)
-		rfi_flush_enable(true);
+		enable = true;
 	else if (val == 0)
-		rfi_flush_enable(false);
+		enable = false;
 	else
 		return -EINVAL;
 
+	/* Only do anything if we're changing state */
+	if (enable != rfi_flush)
+		rfi_flush_enable(enable);
+
 	return 0;
 }
 


