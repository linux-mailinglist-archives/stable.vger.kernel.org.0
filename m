Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650113CAB3B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243896AbhGOTSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244301AbhGOTQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A07613ED;
        Thu, 15 Jul 2021 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376344;
        bh=2M7JojDu52S5+PbtEO65Idqxw6cb7+62V046UCki0XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HHDpM0aKZUWRJTE3rzzyv7TpgmdoeCeXlyW1R3gQZ4oBpS1dlzLDGJVs0N+91/8V
         oUPQHvFn8eGCPvZA5jXdC7CQLchXIknFDwCas49AxYDPzEd+ZMEjX1daRA4WwmPiIz
         j4cPZEhkNF4PSqce4I+26rWqp3qPb4fOlEZL+EP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.13 231/266] lkdtm: Enable DOUBLE_FAULT on all architectures
Date:   Thu, 15 Jul 2021 20:39:46 +0200
Message-Id: <20210715182650.217658895@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit f123c42bbeff26bfe8bdb08a01307e92d51eec39 upstream.

Where feasible, I prefer to have all tests visible on all architectures,
but to have them wired to XFAIL. DOUBLE_FAIL was set up to XFAIL, but
wasn't actually being added to the test list.

Fixes: cea23efb4de2 ("lkdtm/bugs: Make double-fault test always available")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-7-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lkdtm/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -177,9 +177,7 @@ static const struct crashtype crashtypes
 	CRASHTYPE(STACKLEAK_ERASING),
 	CRASHTYPE(CFI_FORWARD_PROTO),
 	CRASHTYPE(FORTIFIED_STRSCPY),
-#ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
-#endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	CRASHTYPE(PPC_SLB_MULTIHIT),
 #endif


