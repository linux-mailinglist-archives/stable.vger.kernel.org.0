Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F90C869C0
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404383AbfHHTKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404891AbfHHTK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3600C2184E;
        Thu,  8 Aug 2019 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291426;
        bh=hCOQ/3o6yVkNnmohc565drS708u0WeyH1cciRFIEELU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfpyGFwuw/lsBTWPdKsllhyaQaEHp9X4wpZmwpcpjXFjLZzDp7NyYdvP0PojX5XCp
         ROq45wUXlhFdhh/7SqavVVkUY2s8QIM29MXjlMJwCZGIg4iiKccysmFf/8cRoyJidC
         1+lFjRbyo9dv0x1J7fXWIvSC45fNuOHGnT5XGU30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 10/33] objtool: Add machine_real_restart() to the noreturn list
Date:   Thu,  8 Aug 2019 21:05:17 +0200
Message-Id: <20190808190454.075977122@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 684fb246578b9e81fc7b4ca5c71eae22edb650b2 upstream.

machine_real_restart() is annotated as '__noreturn", so add it to the
objtool noreturn list.  This fixes the following warning with clang and
CONFIG_CC_OPTIMIZE_FOR_SIZE=y:

  arch/x86/kernel/reboot.o: warning: objtool: native_machine_emergency_restart() falls through to next function machine_power_off()

Reported-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lkml.kernel.org/r/791712792aa4431bdd55bf1beb33a169ddf3b4a2.1529423255.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -165,6 +165,7 @@ static int __dead_end_function(struct ob
 		"__reiserfs_panic",
 		"lbug_with_loc",
 		"fortify_panic",
+		"machine_real_restart",
 	};
 
 	if (func->bind == STB_WEAK)


