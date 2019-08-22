Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3742399B78
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391817AbfHVRZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391813AbfHVRZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:02 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 576DB2341F;
        Thu, 22 Aug 2019 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494702;
        bh=KuskfuOVKjAGPbfOzSzo+A3xQaCkC16TE+yWvdw1T8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flKXRFg1vB/2r95saO/2oFqmZOZYRr0rvNA17CghGqveTSSVS4pjN0clMDgYTA48T
         vBFqI+moro6+9XPAi8P1hY4oCzosdrKdEtC/ILvU7nzQrKjWsGIqJTmxmY274fdrXE
         +YBhtK9aaZ3wqo7YIG3Sz9erpk9UD6LdzLwHSkww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 56/71] arm64: compat: Allow single-byte watchpoints on all addresses
Date:   Thu, 22 Aug 2019 10:19:31 -0700
Message-Id: <20190822171730.217037945@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 849adec41203ac5837c40c2d7e08490ffdef3c2c upstream.

Commit d968d2b801d8 ("ARM: 7497/1: hw_breakpoint: allow single-byte
watchpoints on all addresses") changed the validation requirements for
hardware watchpoints on arch/arm/. Update our compat layer to implement
the same relaxation.

Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/hw_breakpoint.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -548,13 +548,14 @@ int arch_validate_hwbkpt_settings(struct
 			/* Aligned */
 			break;
 		case 1:
-			/* Allow single byte watchpoint. */
-			if (info->ctrl.len == ARM_BREAKPOINT_LEN_1)
-				break;
 		case 2:
 			/* Allow halfword watchpoints and breakpoints. */
 			if (info->ctrl.len == ARM_BREAKPOINT_LEN_2)
 				break;
+		case 3:
+			/* Allow single byte watchpoint. */
+			if (info->ctrl.len == ARM_BREAKPOINT_LEN_1)
+				break;
 		default:
 			return -EINVAL;
 		}


