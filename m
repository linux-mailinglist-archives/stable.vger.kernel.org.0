Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0516E2C05AE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgKWMYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbgKWMY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A51820728;
        Mon, 23 Nov 2020 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134268;
        bh=ADGkb+SO72BS0tmY1VjDC9/Gno1LDlpZ7+sdqblBlKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gK+rEPTNtdSQsb4ZU64imNA9EZxpKqhDwTNrsUsK62YaZBxnUKS98MJr9LyXje/Pi
         38dNTMyji4M1Hc2ZTXQDcH4LTZt15IMHp/hFyHFJEua0z3fOBLE5PwxqpsWil4PN/r
         0lsfokxiHqKgByAnXjpqPilBWIAqhFvM8PwXZvu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 10/47] netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()
Date:   Mon, 23 Nov 2020 13:21:56 +0100
Message-Id: <20201123121806.052622284@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
@@ -1186,7 +1186,7 @@ static int netlbl_unlabel_staticlist(str
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
 	u32 skip_addr4 = cb->args[2];
-	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
+	u32 iter_bkt, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
 	struct list_head *iter_list;
 	struct netlbl_af4list *addr4;


