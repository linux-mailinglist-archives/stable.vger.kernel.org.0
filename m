Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A6126BBC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfLSSyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729824AbfLSSyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59FD42465E;
        Thu, 19 Dec 2019 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781641;
        bh=uQRwI7gEVVVBcBGcIcDIIKDHTSgrdvlBCgzwcILLCxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDVarrlPOdYKbXBfcQWzYauxhDlTwisTP7G7ahvsYK2jvvKEOCKnJ5C9CgmNkrROS
         jOVPyv69M2CkTbZDDvT6QVJNUDMi2+2UbS2FPleLl4yX6wmq9rmoYKNfmN2lZXAewk
         a4s3TtpIQb/60YfCkgwYoCBV12R+E7J7bskN+EYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 20/80] xtensa: fix syscall_set_return_value
Date:   Thu, 19 Dec 2019 19:34:12 +0100
Message-Id: <20191219183100.383232228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit c2d9aa3b6e56de56c7f1ed9026ca6ec7cfbeef19 upstream.

syscall return value is in the register a2, not a0.

Cc: stable@vger.kernel.org # v5.0+
Fixes: 9f24f3c1067c ("xtensa: implement tracehook functions and enable HAVE_ARCH_TRACEHOOK")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/include/asm/syscall.h
+++ b/arch/xtensa/include/asm/syscall.h
@@ -51,7 +51,7 @@ static inline void syscall_set_return_va
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->areg[0] = (long) error ? error : val;
+	regs->areg[2] = (long) error ? error : val;
 }
 
 #define SYSCALL_MAX_ARGS 6


