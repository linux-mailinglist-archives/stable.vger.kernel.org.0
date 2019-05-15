Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458B01F2C3
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfEOMGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbfEOLKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C62A20644;
        Wed, 15 May 2019 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918599;
        bh=qHqYD436lNBjdpjbIxT/gzk69CQ7Y+WIg6q/pE/LPDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCxdsaFXdP5G+BIbN/x5vB5Qo2e030DGSShUyWch1t8eAHTuzyi38eFTUIeMW7eq4
         fyAdi+q2L7ngehXz7pw8Rnu/N8eE34NDxMxGeb5iTUKtQc+HpguRY6QgjzZdgWRHKk
         nrIDsDhzwyykjUhPpvvy/q/7ClICwFwtcEmj18JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, sironi@amazon.de,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 193/266] x86/microcode: Make sure boot_cpu_data.microcode is up-to-date
Date:   Wed, 15 May 2019 12:55:00 +0200
Message-Id: <20190515090729.471509443@linuxfoundation.org>
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

From: Prarit Bhargava <prarit@redhat.com>

commit 370a132bb2227ff76278f98370e0e701d86ff752 upstream.

When preparing an MCE record for logging, boot_cpu_data.microcode is used
to read out the microcode revision on the box.

However, on systems where late microcode update has happened, the microcode
revision output in a MCE log record is wrong because
boot_cpu_data.microcode is not updated when the microcode gets updated.

But, the microcode revision saved in boot_cpu_data's microcode member
should be kept up-to-date, regardless, for consistency.

Make it so.

Fixes: fa94d0c6e0f3 ("x86/MCE: Save microcode revision in machine check records")
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: sironi@amazon.de
Link: http://lkml.kernel.org/r/20180731112739.32338-1-prarit@redhat.com
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c   |    4 ++++
 arch/x86/kernel/cpu/microcode/intel.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -712,6 +712,10 @@ int apply_microcode_amd(int cpu)
 	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
 	c->microcode = mc_amd->hdr.patch_id;
 
+	/* Update boot_cpu_data's revision too, if we're on the BSP: */
+	if (c->cpu_index == boot_cpu_data.cpu_index)
+		boot_cpu_data.microcode = mc_amd->hdr.patch_id;
+
 	return 0;
 }
 
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -905,6 +905,10 @@ static int apply_microcode_intel(int cpu
 	uci->cpu_sig.rev = rev;
 	c->microcode = rev;
 
+	/* Update boot_cpu_data's revision too, if we're on the BSP: */
+	if (c->cpu_index == boot_cpu_data.cpu_index)
+		boot_cpu_data.microcode = rev;
+
 	return 0;
 }
 


