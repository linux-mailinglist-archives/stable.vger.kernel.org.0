Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB6528B786
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgJLNoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731392AbgJLNm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E6E1206D9;
        Mon, 12 Oct 2020 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510175;
        bh=hIm/wYYl0doePaPKkN7iO5I3ZmBsb/RHHwm4JJMhybw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yT4l8dSsDkjk4NB6sT/IPNs7EgykIMSlRpTGFLIvl95w9xV76m1lluWwrShBSU8+P
         fSrDZUtV/LKROjPRA7TiaWQ6XlNjv2ouSZGTFHOiq0LNCyLKEgbwz/zcA1mA7ze8Tw
         iRnJrpgT3dsL+5eXdZn4nZhlt2TCn90pvXZKf2Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 45/85] net: team: fix memory leak in __team_options_register
Date:   Mon, 12 Oct 2020 15:27:08 +0200
Message-Id: <20201012132635.027100219@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 9a9e77495958c7382b2438bc19746dd3aaaabb8e upstream.

The variable "i" isn't initialized back correctly after the first loop
under the label inst_rollback gets executed.

The value of "i" is assigned to be option_count - 1, and the ensuing
loop (under alloc_rollback) begins by initializing i--.
Thus, the value of i when the loop begins execution will now become
i = option_count - 2.

Thus, when kfree(dst_opts[i]) is called in the second loop in this
order, (i.e., inst_rollback followed by alloc_rollback),
dst_optsp[option_count - 2] is the first element freed, and
dst_opts[option_count - 1] does not get freed, and thus, a memory
leak is caused.

This memory leak can be fixed, by assigning i = option_count (instead of
option_count - 1).

Fixes: 80f7c6683fe0 ("team: add support for per-port options")
Reported-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
Tested-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/team/team.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -287,7 +287,7 @@ inst_rollback:
 	for (i--; i >= 0; i--)
 		__team_option_inst_del_option(team, dst_opts[i]);
 
-	i = option_count - 1;
+	i = option_count;
 alloc_rollback:
 	for (i--; i >= 0; i--)
 		kfree(dst_opts[i]);


