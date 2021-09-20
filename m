Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C38412501
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349154AbhITSlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381637AbhITSjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DE463327;
        Mon, 20 Sep 2021 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159018;
        bh=XZ3OOusOdLmmB63r+AVWl5u+lWawr9Lg7iJ70qgnZRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpUFz+CL37M4b8RVL9XDFxVmCUsOwEwqiuUg2wo0w/bbIS/xdIicQpKZhhgjAoDhg
         3VW9plE+nFiYd9zuAR+vcy9VPhxzIR8tboFBx5KKy9cjowbaX4u/TIxhlcnK0lqOW0
         NsKcAgBBqySRxahXe2VD8FVm/NF+4bthz96Hz2ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 039/168] net: remove the unnecessary check in cipso_v4_doi_free
Date:   Mon, 20 Sep 2021 18:42:57 +0200
Message-Id: <20210920163922.937928633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

commit 9756e44fd4d283ebcc94df353642f322428b73de upstream.

The commit 733c99ee8be9 ("net: fix NULL pointer reference in
cipso_v4_doi_free") was merged by a mistake, this patch try
to cleanup the mess.

And we already have the commit e842cb60e8ac ("net: fix NULL
pointer reference in cipso_v4_doi_free") which fixed the root
cause of the issue mentioned in it's description.

Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/cipso_ipv4.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -465,16 +465,14 @@ void cipso_v4_doi_free(struct cipso_v4_d
 	if (!doi_def)
 		return;
 
-	if (doi_def->map.std) {
-		switch (doi_def->type) {
-		case CIPSO_V4_MAP_TRANS:
-			kfree(doi_def->map.std->lvl.cipso);
-			kfree(doi_def->map.std->lvl.local);
-			kfree(doi_def->map.std->cat.cipso);
-			kfree(doi_def->map.std->cat.local);
-			kfree(doi_def->map.std);
-			break;
-		}
+	switch (doi_def->type) {
+	case CIPSO_V4_MAP_TRANS:
+		kfree(doi_def->map.std->lvl.cipso);
+		kfree(doi_def->map.std->lvl.local);
+		kfree(doi_def->map.std->cat.cipso);
+		kfree(doi_def->map.std->cat.local);
+		kfree(doi_def->map.std);
+		break;
 	}
 	kfree(doi_def);
 }


