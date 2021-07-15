Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6C33CA980
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbhGOTG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241099AbhGOTFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA606613EE;
        Thu, 15 Jul 2021 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375729;
        bh=1tqM7/OZJmjCmbVM0r30LOSGKM98unFp0oG6gavf3kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYpy/o7jmQBGizibD4x3vUpNPY56ZOlyOSiwBDATpIDgjxtCKcwCFBak6VQP+yXAw
         1ZmATqUX8YHfXhtYeMtQx7UkX67kyuAbR8yIsWePIuFq2gegA371hfjqS9a99wwB/R
         nSohljGUEf0elA/320RgQXBH+xT/5urDZiSI/XWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.12 204/242] lkdtm/bugs: XFAIL UNALIGNED_LOAD_STORE_WRITE
Date:   Thu, 15 Jul 2021 20:39:26 +0200
Message-Id: <20210715182629.204663305@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit a15676ac8f24a9ac5fd881cf17be4be13fa0910a upstream.

When built under CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, this test is
expected to fail (i.e. not trip an exception).

Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-5-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lkdtm/bugs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -144,6 +144,9 @@ void lkdtm_UNALIGNED_LOAD_STORE_WRITE(vo
 	if (*p == 0)
 		val = 0x87654321;
 	*p = val;
+
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+		pr_err("XFAIL: arch has CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS\n");
 }
 
 void lkdtm_SOFTLOCKUP(void)


