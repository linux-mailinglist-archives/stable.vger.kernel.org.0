Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6035CB5A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfGBIHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbfGBIHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9257C21479;
        Tue,  2 Jul 2019 08:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054853;
        bh=mqaPR9roc8u1JqDgLA/WT7+JVA2ReSlXZxt8V+6uY8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x09wJTucT1s0XAw063SyAfdWmpHNxKNw82OikI0GfV/uCn5szNy1dyRetGTYQVtc6
         Gqe2hTHnAeScJ1De+zcLiQ5WUxRCtKNkeQl/Wh2kzgnM+NxOJgty8jfMYnqv/vTisk
         RUV+ybdZ+/GFem4KKc35eV3Btd8NrO/yF9BUmGY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JingYi Hou <houjingyi647@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 54/72] net: remove duplicate fetch in sock_getsockopt
Date:   Tue,  2 Jul 2019 10:01:55 +0200
Message-Id: <20190702080127.383587532@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JingYi Hou <houjingyi647@gmail.com>

[ Upstream commit d0bae4a0e3d8c5690a885204d7eb2341a5b4884d ]

In sock_getsockopt(), 'optlen' is fetched the first time from userspace.
'len < 0' is then checked. Then in condition 'SO_MEMINFO', 'optlen' is
fetched the second time from userspace.

If change it between two fetches may cause security problems or unexpected
behaivor, and there is no reason to fetch it a second time.

To fix this, we need to remove the second fetch.

Signed-off-by: JingYi Hou <houjingyi647@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1348,9 +1348,6 @@ int sock_getsockopt(struct socket *sock,
 	{
 		u32 meminfo[SK_MEMINFO_VARS];
 
-		if (get_user(len, optlen))
-			return -EFAULT;
-
 		sk_get_meminfo(sk, meminfo);
 
 		len = min_t(unsigned int, len, sizeof(meminfo));


