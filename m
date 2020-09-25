Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA6C2787A5
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgIYMtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgIYMtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4E121D7A;
        Fri, 25 Sep 2020 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038154;
        bh=vfeYz1uzPXeSvrxX0hjIcfVWC4IOVSdlaZSE1O6JE1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ3uibVNRJuvZmiam4vnYVSqC0O/3ycTm8QKCm0GNP/IHLtcaWtaRq0tK4B8WeuCJ
         jSH0bCAetGfhREtG+72JX73dpNIZLUBTxB7Lqjtr+oIo+2imUWqtjgMR6MbkwUEjDj
         r0GpkGn37zFGHFRRl95ktG+oHJbV3+yElK0oRDh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 22/56] net: sched: initialize with 0 before setting erspan md->u
Date:   Fri, 25 Sep 2020 14:48:12 +0200
Message-Id: <20200925124731.152136754@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8e1b3ac4786680c2d2b5a24e38a2d714c3bcd1ef ]

In fl_set_erspan_opt(), all bits of erspan md was set 1, as this
function is also used to set opt MASK. However, when setting for
md->u.index for opt VALUE, the rest bits of the union md->u will
be left 1. It would cause to fail the match of the whole md when
version is 1 and only index is set.

This patch is to fix by initializing with 0 before setting erspan
md->u.

Reported-by: Shuang Li <shuali@redhat.com>
Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1215,6 +1215,7 @@ static int fl_set_erspan_opt(const struc
 		}
 		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
 			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
+			memset(&md->u, 0x00, sizeof(md->u));
 			md->u.index = nla_get_be32(nla);
 		}
 	} else if (md->version == 2) {


