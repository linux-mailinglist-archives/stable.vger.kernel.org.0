Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74832F7B66
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbhAONBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733041AbhAOMc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2433A23884;
        Fri, 15 Jan 2021 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713962;
        bh=/6OtgpkAcLwhpPaznxOQq4fJsVnYKg8lwYWNpIgt+b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSkwo2gtCY4iH4supeAAhzEoD56ph6f/6VCHphc92c74GEmJOFqNf8Wg4BH7l2DwB
         zB2+t/QVEHGIh1SEGNHef6JIhn2U4SHJKluWKTkAGM52ggboeyvEW96+OYrAiV8KTO
         TwbsXwfwVIiayMnHqu9LSNr3Wq4Z/C5s4GJg1S+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/43] net: vlan: avoid leaks on register_vlan_dev() failures
Date:   Fri, 15 Jan 2021 13:27:35 +0100
Message-Id: <20210115121957.312655457@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 55b7ab1178cbf41f979ff83236d3321ad35ed2ad ]

VLAN checks for NETREG_UNINITIALIZED to distinguish between
registration failure and unregistration in progress.

Since commit cb626bf566eb ("net-sysfs: Fix reference count leak")
registration failure may, however, result in NETREG_UNREGISTERED
as well as NETREG_UNINITIALIZED.

This fix is similer to cebb69754f37 ("rtnetlink: Fix
memory(net_device) leak when ->newlink fails")

Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -277,7 +277,8 @@ static int register_vlan_device(struct n
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED)
+	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
+	    new_dev->reg_state == NETREG_UNREGISTERED)
 		free_netdev(new_dev);
 	return err;
 }


