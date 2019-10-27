Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC53E67C6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbfJ0VYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfJ0VYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487D021726;
        Sun, 27 Oct 2019 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211453;
        bh=RubsdF5eC05TQrpCG2qVm9r9dCaPE5/p/TvTqSMGQNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6uzKlPqtqNKhDgciiILLUIaXwTt6/hjM3r+FU3Cu09hHD0jg1BXvwzyvP/ww/r9l
         Ts2y4/CMICkPrVczlLAfzsNJsDyJ5X9pgyoEazHCDWKrReDm14imRP63MSEwYk4RyM
         s2QHI+pB5H41IQU/gHrHF8fEvkEnGjwMOL1jcYE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.3 157/197] xtensa: fix change_bit in exclusive access option
Date:   Sun, 27 Oct 2019 22:01:15 +0100
Message-Id: <20191027203400.160075359@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 775fd6bfefc66a8c33e91dd9687ed530643b954d upstream.

change_bit implementation for XCHAL_HAVE_EXCLUSIVE case changes all bits
except the one required due to copy-paste error from clear_bit.

Cc: stable@vger.kernel.org # v5.2+
Fixes: f7c34874f04a ("xtensa: add exclusive atomics support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/include/asm/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -148,7 +148,7 @@ static inline void change_bit(unsigned i
 			"       getex   %0\n"
 			"       beqz    %0, 1b\n"
 			: "=&a" (tmp)
-			: "a" (~mask), "a" (p)
+			: "a" (mask), "a" (p)
 			: "memory");
 }
 


