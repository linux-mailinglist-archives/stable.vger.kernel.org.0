Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD245252E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353640AbhKPBrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240845AbhKOSQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE592633E5;
        Mon, 15 Nov 2021 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998621;
        bh=MslDhKz3KQX37GF5vk86LMZJEmR0jSkWwfTJ3h+jVbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN+guKzUBqovheO72mYjA6BLPn8fk9jIUJnKvpNpbnD1K0haqiQPkJ1sAMLho0KJY
         WpTwh3XSQ9ELwzw3M8vMA6+fEV4n2tieMozl8wLPftHgSFrRAq8WzFVym1Qkw4V0pO
         ppT4+iQXt6TYY61YoaXe5kpa++6SSEM5T7672zuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.10 543/575] x86/mce: Add errata workaround for Skylake SKX37
Date:   Mon, 15 Nov 2021 18:04:28 +0100
Message-Id: <20211115165402.463118603@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jones <davej@codemonkey.org.uk>

commit e629fc1407a63dbb748f828f9814463ffc2a0af0 upstream.

Errata SKX37 is word-for-word identical to the other errata listed in
this workaround.   I happened to notice this after investigating a CMCI
storm on a Skylake host.  While I can't confirm this was the root cause,
spurious corrected errors does sound like a likely suspect.

Fixes: 2976908e4198 ("x86/mce: Do not log spurious corrected mce errors")
Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20211029205759.GA7385@codemonkey.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -526,12 +526,13 @@ bool intel_filter_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	/* MCE errata HSD131, HSM142, HSW131, BDM48, and HSM142 */
+	/* MCE errata HSD131, HSM142, HSW131, BDM48, HSM142 and SKX37 */
 	if ((c->x86 == 6) &&
 	    ((c->x86_model == INTEL_FAM6_HASWELL) ||
 	     (c->x86_model == INTEL_FAM6_HASWELL_L) ||
 	     (c->x86_model == INTEL_FAM6_BROADWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_G)) &&
+	     (c->x86_model == INTEL_FAM6_HASWELL_G) ||
+	     (c->x86_model == INTEL_FAM6_SKYLAKE_X)) &&
 	    (m->bank == 0) &&
 	    ((m->status & 0xa0000000ffffffff) == 0x80000000000f0005))
 		return true;


