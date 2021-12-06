Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7374E469EC5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbhLFPoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379680AbhLFPjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:39:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B31C08EBA9;
        Mon,  6 Dec 2021 07:24:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F17B8111C;
        Mon,  6 Dec 2021 15:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE9EC34901;
        Mon,  6 Dec 2021 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804286;
        bh=EjcFz6qOTfL7XRZQV2qa8K6VpXSHrW5FFEDptSCUrtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mecv4DO24gjWzWMYS0SFlPW70CfpyuX7FNbOXVKOufr/rS0/fL4IdaSbCc3DTfs3Q
         lZOqI20zTdP+aLLDvOYaeCwk0FjZn6cMAgNt/Gql6rw/L1fg1l0ruhNhTpHtjNF44b
         vlW7RFrffah7OjfI50Q7q88EoVTuENRIAJhcJ44M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 092/207] wireguard: allowedips: add missing __rcu annotation to satisfy sparse
Date:   Mon,  6 Dec 2021 15:55:46 +0100
Message-Id: <20211206145613.414038221@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit ae9287811ba75571cd69505d50ab0e612ace8572 upstream.

A __rcu annotation got lost during refactoring, which caused sparse to
become enraged.

Fixes: bf7b042dc62a ("wireguard: allowedips: free empty intermediate nodes when removing single node")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/allowedips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -163,7 +163,7 @@ static bool node_placement(struct allowe
 	return exact;
 }
 
-static inline void connect_node(struct allowedips_node **parent, u8 bit, struct allowedips_node *node)
+static inline void connect_node(struct allowedips_node __rcu **parent, u8 bit, struct allowedips_node *node)
 {
 	node->parent_bit_packed = (unsigned long)parent | bit;
 	rcu_assign_pointer(*parent, node);


