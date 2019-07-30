Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A567B0EB
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 19:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfG3RyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 13:54:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387450AbfG3RyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 13:54:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 18C1660735; Tue, 30 Jul 2019 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564509261;
        bh=SiHOslm33TKp3uM0b2CsOrfbOok3Z7O03LFNxQsXv/M=;
        h=From:To:Cc:Subject:Date:From;
        b=GSBRgNvpCIyCxN55XaPtvtff/kLeu4W3oYvjPtFdbS8ojNyO5XbaucHuwWQgg9Rt+
         GyKh2zM6uHvFWkUk2vAKXRAc8oQHDWxUZ4PAA99UmU+MNRIIRVgjSdZD80pNzjZvXe
         9j1lpOFee2Ivi2O7lZBD+bgT6c/Xxs+jkicD/uyQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from isaacm-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: isaacm@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3F9C60364;
        Tue, 30 Jul 2019 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564509260;
        bh=SiHOslm33TKp3uM0b2CsOrfbOok3Z7O03LFNxQsXv/M=;
        h=From:To:Cc:Subject:Date:From;
        b=HhkLI3mnLCUAvo6B+gyuVgHIEoUFryU4bKpFS+qp4AwVZ3Ac7QNXZRSylqSO8lK/A
         eLdYQt8nc/CJHzTfrqDVNiWy31besAPLEAzMofVSM3pmOcpq8yuyZHvmdrrfe/nYEd
         g2Obgc+iVNjkBmpW/KOjhrJEY0XM3t+pA7ZtTxKk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F3F9C60364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=isaacm@codeaurora.org
From:   "Isaac J. Manjarres" <isaacm@codeaurora.org>
To:     keescook@chromium.org, crecklin@redhat.com
Cc:     "Isaac J. Manjarres" <isaacm@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        psodagud@codeaurora.org, tsoni@codeaurora.org,
        eberman@codeaurora.org, stable@vger.kernel.org
Subject: [PATCH] mm/usercopy: Use memory range to be accessed for wraparound check
Date:   Tue, 30 Jul 2019 10:54:13 -0700
Message-Id: <1564509253-23287-1-git-send-email-isaacm@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, when checking to see if accessing n bytes starting at
address "ptr" will cause a wraparound in the memory addresses,
the check in check_bogus_address() adds an extra byte, which is
incorrect, as the range of addresses that will be accessed is
[ptr, ptr + (n - 1)].

This can lead to incorrectly detecting a wraparound in the
memory address, when trying to read 4 KB from memory that is
mapped to the the last possible page in the virtual address
space, when in fact, accessing that range of memory would not
cause a wraparound to occur.

Use the memory range that will actually be accessed when
considering if accessing a certain amount of bytes will cause
the memory address to wrap around.

Fixes: f5509cc18daa ("mm: Hardened usercopy")
Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Cc: stable@vger.kernel.org
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 mm/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 2a09796..98e92486 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -147,7 +147,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 				       bool to_user)
 {
 	/* Reject if object wraps past end of memory. */
-	if (ptr + n < ptr)
+	if (ptr + (n - 1) < ptr)
 		usercopy_abort("wrapped address", NULL, to_user, 0, ptr + n);
 
 	/* Reject if NULL or ZERO-allocation. */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

