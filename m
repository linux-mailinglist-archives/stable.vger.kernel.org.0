Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1262C0654
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgKWM3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgKWM3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F34F21D7A;
        Mon, 23 Nov 2020 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134593;
        bh=Q1TdgDXmY1kSWooOCJWJqG1UQDpxrak7pKjGdM5pMiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynPgI7uLVLn4BLtusJroVYtjAgy0CnjsnuUl6xtPkqxmhvZ4RDz/3OyP6D/GKmMdv
         +001xzzcI/nmlQgWnz8ThFXYxNYem71gPJ0NfFUIkUNItlEudoCvF2ilCu9a4xeY3c
         qdQZVkX97ALMvPjRhg2esWpPJSiFd9k6CVSGfBQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 14/91] netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()
Date:   Mon, 23 Nov 2020 13:21:34 +0100
Message-Id: <20201123121809.995006720@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 1ba86d4366e023d96df3dbe415eea7f1dc08c303 ]

Static checking revealed that a previous fix to
netlbl_unlabel_staticlist() leaves a stack variable uninitialized,
this patches fixes that.

Fixes: 866358ec331f ("netlabel: fix our progress tracking in netlbl_unlabel_staticlist()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Link: https://lore.kernel.org/r/160530304068.15651.18355773009751195447.stgit@sifl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_unlabeled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1180,7 +1180,7 @@ static int netlbl_unlabel_staticlist(str
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
 	u32 skip_addr4 = cb->args[2];
-	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
+	u32 iter_bkt, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
 	struct list_head *iter_list;
 	struct netlbl_af4list *addr4;


