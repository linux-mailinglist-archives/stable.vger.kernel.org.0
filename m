Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2FDBEED4F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbfKDWFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389256AbfKDWFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:23 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7425A2084D;
        Mon,  4 Nov 2019 22:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905123;
        bh=eAV/jO+TLQ0C4hnh/l6aSCSrwb/gp7mDLddYD/SJ/m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFVxHpp7ILxlqXt3aFPXbwRII9Z9i3o8++D6dMfw+V5/UvT9b3YnMbFbppKTRPzGP
         dQsUd3h3QULLXxMSRT514nbOS771cxQntjttlUL7MjnD/wSTDPUuxlpBX5iVbD+BHC
         LMBwcs3OzT7KqKz+za9yYM1M/rJ/NUJYl4YE3Caw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 035/163] tty: n_hdlc: fix build on SPARC
Date:   Mon,  4 Nov 2019 22:43:45 +0100
Message-Id: <20191104212142.781021204@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 47a7e5e97d4edd7b14974d34f0e5a5560fad2915 ]

Fix tty driver build on SPARC by not using __exitdata.
It appears that SPARC does not support section .exit.data.

Fixes these build errors:

`.exit.data' referenced in section `.exit.text' of drivers/tty/n_hdlc.o: defined in discarded section `.exit.data' of drivers/tty/n_hdlc.o
`.exit.data' referenced in section `.exit.text' of drivers/tty/n_hdlc.o: defined in discarded section `.exit.data' of drivers/tty/n_hdlc.o
`.exit.data' referenced in section `.exit.text' of drivers/tty/n_hdlc.o: defined in discarded section `.exit.data' of drivers/tty/n_hdlc.o
`.exit.data' referenced in section `.exit.text' of drivers/tty/n_hdlc.o: defined in discarded section `.exit.data' of drivers/tty/n_hdlc.o

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 063246641d4a ("format-security: move static strings to const")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/675e7bd9-955b-3ff3-1101-a973b58b5b75@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_hdlc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index e55c79eb64309..98361acd3053f 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -968,6 +968,11 @@ static int __init n_hdlc_init(void)
 	
 }	/* end of init_module() */
 
+#ifdef CONFIG_SPARC
+#undef __exitdata
+#define __exitdata
+#endif
+
 static const char hdlc_unregister_ok[] __exitdata =
 	KERN_INFO "N_HDLC: line discipline unregistered\n";
 static const char hdlc_unregister_fail[] __exitdata =
-- 
2.20.1



