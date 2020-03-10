Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E5217F7B6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCJMlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCJMlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F1C324691;
        Tue, 10 Mar 2020 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844099;
        bh=/kRuxcuHOYsDociFLkbeQUfdfObngkhGQ3sS+2p7z/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGHtZVQnu3HYAKaIUSK38ImPKd7U0OWcewFVkoZBafG7SIwBOh0dw7VtPrIO5EqRM
         /pcBRyzRbTU5xOy8//GeqtumAh+tyOqAENC1QZWmlIKfuQ8xpxB1Z9ViL5E+8/T+3v
         caYjgFLDYKbKv+sm4T25jLtAS77EvhOFnh4TDK/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>
Subject: [PATCH 4.4 31/72] slip: stop double free sl->dev in slip_open
Date:   Tue, 10 Mar 2020 13:38:44 +0100
Message-Id: <20200310123609.077059982@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

After include 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
and e58c19124189 ("slip: Fix use-after-free Read in slip_open") with 4.4.y/4.9.y.
We will trigger a bug since we can double free sl->dev in slip_open. Actually,
we should backport cf124db566e6 ("net: Fix inconsistent teardown and release
of private netdev state.") too since it has delete free_netdev from sl_free_netdev.
Fix it by delete free_netdev from slip_open.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/slip/slip.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -868,7 +868,6 @@ err_free_chan:
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
-	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();


