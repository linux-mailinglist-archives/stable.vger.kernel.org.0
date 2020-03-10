Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28EF17FE5F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgCJMpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgCJMpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2102B246A6;
        Tue, 10 Mar 2020 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844334;
        bh=/kRuxcuHOYsDociFLkbeQUfdfObngkhGQ3sS+2p7z/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KU2y/LE7Z+M3HV30u1oaslEz6DJYM4Saq9kPW6VuZjjpfR15ZwIZbXohfE9TE+8Di
         tCUwYJpY+3k1C8c7XjV9g9ik5u7mAvhthIOQ29EgqF/idFSIK4OyuBIcNyMf5Jg03l
         1YY/j0kHNZmrxrxfxIwi6BlC+FRcXHKH/zJTY7KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>
Subject: [PATCH 4.9 44/88] slip: stop double free sl->dev in slip_open
Date:   Tue, 10 Mar 2020 13:38:52 +0100
Message-Id: <20200310123616.884028679@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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


