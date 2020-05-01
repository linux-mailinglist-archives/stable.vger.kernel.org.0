Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED741C15B7
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgEANcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbgEANcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:32:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFB624954;
        Fri,  1 May 2020 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339938;
        bh=sxF3p7Zg0IrREZE4/Q9IA6NEcnxSI01vA+H+g75AhZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVvGoVfBnbSqz4m3eV+DWz9mHX42NG3baKVMolyELCIvIuVVYZ9cxNqQ3vi6KEUPO
         a82M7nzjG45NB5luhFTGYuLthSNj/n7kruI+EApElAPYpyh3hPPkQ1jOy+6C0RGu42
         8pzwSvo5XisKG4lSXI3QZogOFCk7ubru+fTqJZGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 032/117] team: fix hang in team_mode_get()
Date:   Fri,  1 May 2020 15:21:08 +0200
Message-Id: <20200501131548.647035109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1c30fbc76b8f0c07c92a8ca4cd7c456612e17eb5 ]

When team mode is changed or set, the team_mode_get() is called to check
whether the mode module is inserted or not. If the mode module is not
inserted, it calls the request_module().
In the request_module(), it creates a child process, which is
the "modprobe" process and waits for the done of the child process.
At this point, the following locks were used.
down_read(&cb_lock()); by genl_rcv()
    genl_lock(); by genl_rcv_msc()
        rtnl_lock(); by team_nl_cmd_options_set()
            mutex_lock(&team->lock); by team_nl_team_get()

Concurrently, the team module could be removed by rmmod or "modprobe -r"
The __exit function of team module is team_module_exit(), which calls
team_nl_fini() and it tries to acquire following locks.
down_write(&cb_lock);
    genl_lock();
Because of the genl_lock() and cb_lock, this process can't be finished
earlier than request_module() routine.

The problem secenario.
CPU0                                     CPU1
team_mode_get
    request_module()
                                         modprobe -r team_mode_roundrobin
                                                     team <--(B)
        modprobe team <--(A)
            team_mode_roundrobin

By request_module(), the "modprobe team_mode_roundrobin" command
will be executed. At this point, the modprobe process will decide
that the team module should be inserted before team_mode_roundrobin.
Because the team module is being removed.

By the module infrastructure, the same module insert/remove operations
can't be executed concurrently.
So, (A) waits for (B) but (B) also waits for (A) because of locks.
So that the hang occurs at this point.

Test commands:
    while :
    do
        teamd -d &
	killall teamd &
	modprobe -rv team_mode_roundrobin &
    done

The approach of this patch is to hold the reference count of the team
module if the team module is compiled as a module. If the reference count
of the team module is not zero while request_module() is being called,
the team module will not be removed at that moment.
So that the above scenario could not occur.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -480,6 +480,9 @@ static const struct team_mode *team_mode
 	struct team_mode_item *mitem;
 	const struct team_mode *mode = NULL;
 
+	if (!try_module_get(THIS_MODULE))
+		return NULL;
+
 	spin_lock(&mode_list_lock);
 	mitem = __find_mode(kind);
 	if (!mitem) {
@@ -495,6 +498,7 @@ static const struct team_mode *team_mode
 	}
 
 	spin_unlock(&mode_list_lock);
+	module_put(THIS_MODULE);
 	return mode;
 }
 


