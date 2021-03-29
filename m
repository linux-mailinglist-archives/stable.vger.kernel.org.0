Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86D34C789
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhC2IQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhC2IOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CEF7619BC;
        Mon, 29 Mar 2021 08:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005668;
        bh=Oy4NPOQ2oFcndlDvPhAMGvJ8TqT+mWlV5wxyRo1/Wb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBpauSkXl/foNr9Iljy+PjZbzNney4Xq2cFiL3fYKVBynutuoY4hgvQydlOHr2kIB
         lm9i0s1uRPLZAAwTIe/G1bidhruZuX2cBNiU85kYMEBijr8J3AwOjmHxS4cZVpynWd
         MyuphwfLpWmobUIJdXAqq84AulKp6lBut0SCvHEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 040/111] platform/x86: intel-vbtn: Stop reporting SW_DOCK events
Date:   Mon, 29 Mar 2021 09:57:48 +0200
Message-Id: <20210329075616.513539364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 538d2dd0b9920334e6596977a664e9e7bac73703 upstream.

Stop reporting SW_DOCK events because this breaks suspend-on-lid-close.

SW_DOCK should only be reported for docking stations, but all the DSDTs in
my DSDT collection which use the intel-vbtn code, always seem to use this
for 2-in-1s / convertibles and set SW_DOCK=1 when in laptop-mode (in tandem
with setting SW_TABLET_MODE=0).

This causes userspace to think the laptop is docked to a port-replicator
and to disable suspend-on-lid-close, which is undesirable.

Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.

Note this may theoretically cause us to stop reporting SW_DOCK on some
device where the 0xCA and 0xCB intel-vbtn events are actually used for
reporting docking to a classic docking-station / port-replicator but
I'm not aware of any such devices.

Also the most important thing is that we only report SW_DOCK when it
reliably reports being docked to a classic docking-station without any
false positives, which clearly is not the case here. If there is a
chance of reporting false positives then it is better to not report
SW_DOCK at all.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321163513.72328-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel-vbtn.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -46,8 +46,16 @@ static const struct key_entry intel_vbtn
 };
 
 static const struct key_entry intel_vbtn_switchmap[] = {
-	{ KE_SW,     0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
-	{ KE_SW,     0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
+	/*
+	 * SW_DOCK should only be reported for docking stations, but DSDTs using the
+	 * intel-vbtn code, always seem to use this for 2-in-1s / convertibles and set
+	 * SW_DOCK=1 when in laptop-mode (in tandem with setting SW_TABLET_MODE=0).
+	 * This causes userspace to think the laptop is docked to a port-replicator
+	 * and to disable suspend-on-lid-close, which is undesirable.
+	 * Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.
+	 */
+	{ KE_IGNORE, 0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
+	{ KE_IGNORE, 0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
 	{ KE_SW,     0xCC, { .sw = { SW_TABLET_MODE, 1 } } },	/* Tablet */
 	{ KE_SW,     0xCD, { .sw = { SW_TABLET_MODE, 0 } } },	/* Laptop */
 };


