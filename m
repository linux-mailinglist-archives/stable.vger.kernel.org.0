Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2504106F16
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfKVK4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbfKVK4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D60D20715;
        Fri, 22 Nov 2019 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420199;
        bh=wxOmL7IPVisL9tNKCQ8v1irIg/JlK6orRS2rAjsOAy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmSdvbl9gSEYKPr/Jtxoh2tK8uOiPJ8L7xbtDyAh4nisE89tEHO7yyVbHG++sGhh8
         inQF/vMV9BZeo/HCZ0Pt1JjoewJquq34Xusx+c/iuZyKl0ynRNCWNipizpCNwR5K66
         BawGVX6eaamCdApmehCK4fNAvQ2P7b7r1VIY16lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 003/220] tee: optee: add missing of_node_put after of_device_is_available
Date:   Fri, 22 Nov 2019 11:26:08 +0100
Message-Id: <20191122100912.931081612@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

commit c7c0d8df0b94a67377555a550b8d66ee2ad2f4ed upstream.

Add an of_node_put when a tested device node is not available.

The semantic patch that fixes this problem is as follows
(http://coccinelle.lip6.fr):

// <smpl>
@@
identifier f;
local idexpression e;
expression x;
@@

e = f(...);
... when != of_node_put(e)
    when != x = e
    when != e = x
    when any
if (<+...of_device_is_available(e)...+>) {
  ... when != of_node_put(e)
(
  return e;
|
+ of_node_put(e);
  return ...;
)
}
// </smpl>

Fixes: db878f76b9ff ("tee: optee: take DT status property into account")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tee/optee/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -696,8 +696,10 @@ static int __init optee_driver_init(void
 		return -ENODEV;
 
 	np = of_find_matching_node(fw_np, optee_match);
-	if (!np || !of_device_is_available(np))
+	if (!np || !of_device_is_available(np)) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	optee = optee_probe(np);
 	of_node_put(np);


