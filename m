Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0078B469DF0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378913AbhLFPer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47184 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386840AbhLFPaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53FDE61316;
        Mon,  6 Dec 2021 15:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E515C34900;
        Mon,  6 Dec 2021 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804397;
        bh=Ovr7XKnb1oOphoNa74Lmj9m5QxQP7xhfX2Y96/z16UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbO/3kUK6k1InhUiftD76soo/YQzFXDGfH0qIVX5LXqpNj0mB3YHWw/c+83DOfDyn
         VdNz4Os6NX0PbHdz6E1UUThG8b4/LC7YL7u0hqdqG95WafUYepyNyfvOUI2wslUuZH
         PobV4L4xL1izlO59I8IViv4w3NdAep1s1Jh2z0Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 131/207] octeontx2-af: Fix a memleak bug in rvu_mbox_init()
Date:   Mon,  6 Dec 2021 15:56:25 +0100
Message-Id: <20211206145614.769599074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

commit e07a097b4986afb8f925d0bb32612e1d3e88ce15 upstream.

In rvu_mbox_init(), mbox_regions is not freed or passed out
under the switch-default region, which could lead to a memory leak.

Fix this bug by changing 'return err' to 'goto free_regions'.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_OCTEONTX2_AF=y show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 98c561116360 (“octeontx2-af: cn10k: Add mbox support for CN10K platform”)
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Link: https://lore.kernel.org/r/20211130165039.192426-1-zhou1615@umn.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2281,7 +2281,7 @@ static int rvu_mbox_init(struct rvu *rvu
 			goto free_regions;
 		break;
 	default:
-		return err;
+		goto free_regions;
 	}
 
 	mw->mbox_wq = alloc_workqueue(name,


