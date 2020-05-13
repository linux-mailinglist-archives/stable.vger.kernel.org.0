Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A93E1D0CDA
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgEMJsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732982AbgEMJsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37F223129;
        Wed, 13 May 2020 09:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363281;
        bh=BfybzEoGoGSltv3vjXKW5MF1GYRiUuH1eR51cBKh3fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDfzuay+noE6xqBqx7MNJ5wm+OMa8c0v0oEfJ6nMIEyTen9gxur0LbuBE24Z982Ek
         k5R4z5eR8XW732lGEK9daL3iH582+WOnVXFjmg01EEYrpd+HvtIznhtS/ADwrU56ba
         GtV+K3FmWzsKoKkKBNK4WOSGMzwNEw5fu4Ozy0xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 11/90] dp83640: reverse arguments to list_add_tail
Date:   Wed, 13 May 2020 11:44:07 +0200
Message-Id: <20200513094410.291173235@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit 865308373ed49c9fb05720d14cbf1315349b32a9 ]

In this code, it appears that phyter_clocks is a list head, based on
the previous list_for_each, and that clock->list is intended to be a
list element, given that it has just been initialized in
dp83640_clock_init.  Accordingly, switch the arguments to
list_add_tail, which takes the list head as the second argument.

Fixes: cb646e2b02b27 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83640.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1119,7 +1119,7 @@ static struct dp83640_clock *dp83640_clo
 		goto out;
 	}
 	dp83640_clock_init(clock, bus);
-	list_add_tail(&phyter_clocks, &clock->list);
+	list_add_tail(&clock->list, &phyter_clocks);
 out:
 	mutex_unlock(&phyter_clocks_lock);
 


