Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383DC157BB5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgBJMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbgBJMfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5232A20838;
        Mon, 10 Feb 2020 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338153;
        bh=XEtgZaV6GaEQUR2wpTx5eSE3iu9dhQoZ5ofdCYCYJmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erQXBidJzhvpc5G+IRlnvOO//hKeKP8I/wNT5BOEb8C1kxJy3msdCDw+yGa4VZidt
         BFOxMWCJkfBypY6ubC8jtPfNhP0Rlcfe7JOFg13qmPryWOISIPzR0Lowa41TrBMKlB
         1bI1SpPWmBop82EE+5ITVOsbptnplQd7K57Bm1ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.19 118/195] xen/balloon: Support xend-based toolstack take two
Date:   Mon, 10 Feb 2020 04:32:56 -0800
Message-Id: <20200210122316.917651317@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -83,7 +83,7 @@ static void watch_target(struct xenbus_w
 				  "%llu", &static_max) == 1))
 			static_max >>= PAGE_SHIFT - 10;
 		else
-			static_max = new_target;
+			static_max = balloon_stats.current_pages;
 
 		target_diff = (xen_pv_domain() || xen_initial_domain()) ? 0
 				: static_max - balloon_stats.target_pages;


