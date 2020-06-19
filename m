Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E09201095
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404864AbgFSPbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404854AbgFSPbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47B3920734;
        Fri, 19 Jun 2020 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580700;
        bh=Aau8Fz/kmFsQg6cbPI1I441hvSSkrvN3v8hY2af6fyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHVWLnfR4gONxmB5EIYvqzthxgq1tnppB3ODtdjm0gIH+HmPVpVcSRT+x9CJuIzUM
         1mkz+9qelkt7y2FRiT8766VWoi8mkvT1cREqkaF10hvFsY+BpM5d1qaWo6VUNJ/W+1
         AeqXo10b1PEIBjVY/h8sYuF0YEoiQXWwF8OdEfck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weiyi Lu <weiyi.lu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.7 309/376] clk: mediatek: assign the initial value to clk_init_data of mtk_mux
Date:   Fri, 19 Jun 2020 16:33:47 +0200
Message-Id: <20200619141724.963339494@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weiyi Lu <weiyi.lu@mediatek.com>

commit 571cfadcc628dd5591444f7289e27445ea732f4c upstream.

When some new clock supports are introduced, e.g. [1]
it might lead to an error although it should be NULL because
clk_init_data is on the stack and it might have random values
if using without initialization.
Add the missing initial value to clk_init_data.

[1] https://android-review.googlesource.com/c/kernel/common/+/1278046

Fixes: a3ae549917f1 ("clk: mediatek: Add new clkmux register API")
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1590560749-29136-1-git-send-email-weiyi.lu@mediatek.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mediatek/clk-mux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/mediatek/clk-mux.c
+++ b/drivers/clk/mediatek/clk-mux.c
@@ -160,7 +160,7 @@ struct clk *mtk_clk_register_mux(const s
 				 spinlock_t *lock)
 {
 	struct mtk_clk_mux *clk_mux;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk *clk;
 
 	clk_mux = kzalloc(sizeof(*clk_mux), GFP_KERNEL);


