Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8087F2F307
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfE3EZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbfE3DOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7B223D83;
        Thu, 30 May 2019 03:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186080;
        bh=uhUTGgs0Qbrk39i5znOTzYXW2P3rC5XQlxdAYOie0qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQP0exsI1gWtQ7pIRxsaEYjEilQqCcOAsEk9g24XZxrmI/mWRhHBRAyCQkVy3CBxK
         y3OKuLnH3TkGYvhcARb0G71CoYEcbSuXjBXQ+AmDdLs6uitiMP9E5RgqsbDIV6frv4
         F7bWVTwbqxzJdcG8cM2VYvMiRUAv+0T6zlZ10F7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jann Horn <jannh@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 199/346] x86/microcode: Fix the ancient deprecated microcode loading method
Date:   Wed, 29 May 2019 20:04:32 -0700
Message-Id: <20190530030551.315782824@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 24613a04ad1c0588c10f4b5403ca60a73d164051 ]

Commit

  2613f36ed965 ("x86/microcode: Attempt late loading only when new microcode is present")

added the new define UCODE_NEW to denote that an update should happen
only when newer microcode (than installed on the system) has been found.

But it missed adjusting that for the old /dev/cpu/microcode loading
interface. Fix it.

Fixes: 2613f36ed965 ("x86/microcode: Attempt late loading only when new microcode is present")
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com>
Link: https://lkml.kernel.org/r/20190405133010.24249-3-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 97f9ada9cedaf..fc70d39b804f0 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -418,8 +418,9 @@ static int do_microcode_update(const void __user *buf, size_t size)
 		if (ustate == UCODE_ERROR) {
 			error = -1;
 			break;
-		} else if (ustate == UCODE_OK)
+		} else if (ustate == UCODE_NEW) {
 			apply_microcode_on_target(cpu);
+		}
 	}
 
 	return error;
-- 
2.20.1



