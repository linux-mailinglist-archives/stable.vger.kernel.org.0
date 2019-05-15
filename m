Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194461F2B6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfEOLJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbfEOLJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A702084E;
        Wed, 15 May 2019 11:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918587;
        bh=PkryYENoIwkRY8gFUuxRQ7rev2NbfZre0BXHHFrzexU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/tZZfTfzqAL+oZoeyxcdyh+KizIKAgsEIsxRzjpgud8QM8Hp/KCjBSBAM3MA+/Ym
         r2uftRxI3WhgR+8n2X1/djmV9aIYVEQnmw/WHlmtdl6bVJI8B4SH/8B01YJXZ1BJZF
         gHz5D511ULuc/LbIY5FPEYX24CdLweCdbUGw6czE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        KarimAllah Ahmed <karahmed@amazon.de>,
        andrew.cooper3@citrix.com, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 189/266] x86/bugs: Switch the selection of mitigation from CPU vendor to CPU features
Date:   Wed, 15 May 2019 12:54:56 +0200
Message-Id: <20190515090729.335325918@linuxfoundation.org>
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

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 108fab4b5c8f12064ef86e02cb0459992affb30f upstream.

Both AMD and Intel can have SPEC_CTRL_MSR for SSBD.

However AMD also has two more other ways of doing it - which
are !SPEC_CTRL MSR ways.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: kvm@vger.kernel.org
Cc: KarimAllah Ahmed <karahmed@amazon.de>
Cc: andrew.cooper3@citrix.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Link: https://lkml.kernel.org/r/20180601145921.9500-4-konrad.wilk@oracle.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -526,17 +526,12 @@ static enum ssb_mitigation __init __ssb_
 		 * Intel uses the SPEC CTRL MSR Bit(2) for this, while AMD may
 		 * use a completely different MSR and bit dependent on family.
 		 */
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-		case X86_VENDOR_AMD:
-			if (!static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-				x86_amd_ssb_disable();
-				break;
-			}
+		if (!static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+			x86_amd_ssb_disable();
+		else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
 			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
-			break;
 		}
 	}
 


