Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EEC50730
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfFXKFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbfFXKFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:20 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F61208E3;
        Mon, 24 Jun 2019 10:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370719;
        bh=JnnPt4jzV+wGPPsHcZgFqR7TkJCurgQAYoVCh5BMDfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qp3pl9jfm0pXPEc4TWrBQFfeMxs13dA26KcQsNcxgcKDsiCqbCp+0DSnLZjVgfZx
         71z9GXNZXV1DPf4dYHOu47j4JjgGduj3AM267TccjYOS9dlyndingUTHToJTJcQEZR
         zcB/Wp4HdShSQycTP39AcbFOPLw3cG1cTt0gGh7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/90] arm64: Silence gcc warnings about arch ABI drift
Date:   Mon, 24 Jun 2019 17:56:56 +0800
Message-Id: <20190624092318.394884410@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ebcc5928c5d925b1c8d968d9c89cdb0d0186db17 ]

Since GCC 9, the compiler warns about evolution of the
platform-specific ABI, in particular relating for the marshaling of
certain structures involving bitfields.

The kernel is a standalone binary, and of course nobody would be
so stupid as to expose structs containing bitfields as function
arguments in ABI.  (Passing a pointer to such a struct, however
inadvisable, should be unaffected by this change.  perf and various
drivers rely on that.)

So these warnings do more harm than good: turn them off.

We may miss warnings about future ABI drift, but that's too bad.
Future ABI breaks of this class will have to be debugged and fixed
the traditional way unless the compiler evolves finer-grained
diagnostics.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 35649ee8ad56..c12ff63265a9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -51,6 +51,7 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
+KBUILD_CFLAGS	+= -Wno-psabi
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
-- 
2.20.1



