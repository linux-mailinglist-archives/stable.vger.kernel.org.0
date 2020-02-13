Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43B215C60B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbgBMP4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbgBMPZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:26 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC0524691;
        Thu, 13 Feb 2020 15:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607525;
        bh=6BvIOzEilr42zeZ5zmuT/u0bTWUdZpnU7Nz+IlT1MaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZBeiDIFCRf6Bjr6jWhhZLRSVkJLD4ApSPBRUfKAUPXIPSg7g/ZDFu330Utn95s7W
         Ib5FAUNErEmZ9+r8b0QmDDQoY4uNhIpnyxjfIIms45iKNCkzR3uSGdFD8iUZY6z8Ca
         aOwFODu2XaH2ZmG29znNtl4JPbs4s6H5cTuurgN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 077/173] xen/balloon: Support xend-based toolstack take two
Date:   Thu, 13 Feb 2020 07:19:40 -0800
Message-Id: <20200213151952.968884331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit eda4eabf86fd6806eaabc23fb90dd056fdac037b upstream.

Commit 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
tried to fix a regression with running on rather ancient Xen versions.
Unfortunately the fix was based on the assumption that xend would
just use another Xenstore node, but in reality only some downstream
versions of xend are doing that. The upstream xend does not write
that Xenstore node at all, so the problem must be fixed in another
way.

The easiest way to achieve that is to fall back to the behavior
before commit 96edd61dcf4436 ("xen/balloon: don't online new memory
initially") in case the static memory maximum can't be read.

This is achieved by setting static_max to the current number of
memory pages known by the system resulting in target_diff becoming
zero.

Fixes: 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: <stable@vger.kernel.org> # 4.13
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -82,7 +82,7 @@ static void watch_target(struct xenbus_w
 				  "%llu", &static_max) == 1))
 			static_max >>= PAGE_SHIFT - 10;
 		else
-			static_max = new_target;
+			static_max = balloon_stats.current_pages;
 
 		target_diff = (xen_pv_domain() || xen_initial_domain()) ? 0
 				: static_max - balloon_stats.target_pages;


