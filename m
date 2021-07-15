Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335EB3CA7C2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhGOS4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241424AbhGOSzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D75D613D7;
        Thu, 15 Jul 2021 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375165;
        bh=1tqM7/OZJmjCmbVM0r30LOSGKM98unFp0oG6gavf3kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUDP2NIQ4MmCr0JUAZttqcXnbVw60KoKCdSKGXMwUP/m45BiokFwsc1fiRKdsf9ty
         bL2GqXXCcORn5dsAPmhKVqz0NgetDmITCgsWzv1Bz6e6G+rvB5aAo9h1xUZXbN2HLV
         Q8tB/9mII/IhNJ3uM4qrpOLGkcT4okEF5cNlKNMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 185/215] lkdtm/bugs: XFAIL UNALIGNED_LOAD_STORE_WRITE
Date:   Thu, 15 Jul 2021 20:39:17 +0200
Message-Id: <20210715182631.973798667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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


