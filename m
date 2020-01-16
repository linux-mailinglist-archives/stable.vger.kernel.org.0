Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F8213FE5B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391581AbgAPXeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404249AbgAPXdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A5D20661;
        Thu, 16 Jan 2020 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217588;
        bh=UYFTwy/8mNp/kF5FDWrxnpyRxnkxPblHvy8mqx408r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd5iygsfBm1DDayRXMz3004rzB5uCXxg2bKCDTAalTeId6lSHzkHqMf7D+Ig3q5cp
         CAcE7WPHcfCb2gAFQWqwKjnlH8//2403jDX04ZuSiuKb32SV7Qomw7BvMZUSuJgAu4
         dksmxauGHW0ByS0G9MhFqkZYWo6VmlRBOmB3ZJNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Dirk Mueller <dmueller@suse.com>,
        Will Deacon <will.deacon@arm.com>,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH 4.14 33/71] arm64: Check for errata before evaluating cpu features
Date:   Fri, 17 Jan 2020 00:18:31 +0100
Message-Id: <20200116231714.391385773@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Mueller <dmueller@suse.com>

commit dc0e36581eb2da1aa3c63ceeff0f10ef1e899b2a upstream.

Since commit d3aec8a28be3b8 ("arm64: capabilities: Restrict KPTI
detection to boot-time CPUs") we rely on errata flags being already
populated during feature enumeration. The order of errata and
features was flipped as part of commit ed478b3f9e4a ("arm64:
capabilities: Group handling of features and errata workarounds").

Return to the orginal order of errata and feature evaluation to
ensure errata flags are present during feature evaluation.

Fixes: ed478b3f9e4a ("arm64: capabilities: Group handling of
    features and errata workarounds")
CC: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Dirk Mueller <dmueller@suse.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1278,9 +1278,9 @@ static void __update_cpu_capabilities(co
 
 static void update_cpu_capabilities(u16 scope_mask)
 {
-	__update_cpu_capabilities(arm64_features, scope_mask, "detected:");
 	__update_cpu_capabilities(arm64_errata, scope_mask,
 				  "enabling workaround for");
+	__update_cpu_capabilities(arm64_features, scope_mask, "detected:");
 }
 
 static int __enable_cpu_capability(void *arg)
@@ -1335,8 +1335,8 @@ __enable_cpu_capabilities(const struct a
 
 static void __init enable_cpu_capabilities(u16 scope_mask)
 {
-	__enable_cpu_capabilities(arm64_features, scope_mask);
 	__enable_cpu_capabilities(arm64_errata, scope_mask);
+	__enable_cpu_capabilities(arm64_features, scope_mask);
 }
 
 /*


