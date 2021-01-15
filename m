Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442C12F79DF
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388147AbhAOMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388558AbhAOMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70D8C23382;
        Fri, 15 Jan 2021 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714370;
        bh=sOh7Oyw6pbVu0OGbLvoihkjiNTcx2S7Dhik0PxGbG3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dohMZSjaF2nZLZKOq7fe0pZtF6pjI+Pez9toqvq9OkDapihYYioBQRCfxTZtJL9j9
         XRvNu/nL9pUOqo50SnEVfKBc67xOew1YtNgIXd7Zq1G2ktmbzNjIUat0ZDk3UQu9zs
         APafB4FDRQ5S5FnBNxbBpBjcBPEtNKh3LcCDpP2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 098/103] can: isotp: isotp_getname(): fix kernel information leak
Date:   Fri, 15 Jan 2021 13:28:31 +0100
Message-Id: <20210115122010.745452600@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit b42b3a2744b3e8f427de79896720c72823af91ad upstream.

Initialize the sockaddr_can structure to prevent a data leak to user space.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20210112091643.11789-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/isotp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1139,6 +1139,7 @@ static int isotp_getname(struct socket *
 	if (peer)
 		return -EOPNOTSUPP;
 
+	memset(addr, 0, sizeof(*addr));
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = so->ifindex;
 	addr->can_addr.tp.rx_id = so->rxid;


