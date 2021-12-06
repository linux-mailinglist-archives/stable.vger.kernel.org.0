Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE97F469D76
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358726AbhLFP3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386630AbhLFP0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB944C08E840;
        Mon,  6 Dec 2021 07:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 620ADB8111A;
        Mon,  6 Dec 2021 15:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84ABC341C2;
        Mon,  6 Dec 2021 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803810;
        bh=EjcFz6qOTfL7XRZQV2qa8K6VpXSHrW5FFEDptSCUrtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niH6rzAdIcm3oIJ7rfVXUMTLzJhSitr0z4Voab5TB6B5CC3y2TloUC2lXIczqTQpB
         57vaybGgXXrNAxZmMnVUfgP4zE0Yio9beUOlJI7nxhFZxn69OXunwaeIbCy6l+9nsb
         WOgCjkM10PWmjsPstt1jMPA73STrjOkbPVytbduk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 054/130] wireguard: allowedips: add missing __rcu annotation to satisfy sparse
Date:   Mon,  6 Dec 2021 15:56:11 +0100
Message-Id: <20211206145601.554850261@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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


