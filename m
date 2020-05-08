Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78C31CAC4A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgEHMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729941AbgEHMwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:52:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B2E924959;
        Fri,  8 May 2020 12:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942339;
        bh=0JdQPdHvUAwfNehrZPdJ0HV1zrRmpMt3IIEHaznFoDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOIgViViyWd2V/yeI1BZdAdcK5G+LktczA8lcUG5LFx70Z1yN4WqQFSAg4yYL5ToP
         rVJ7qCA4lzPMrdybpSoyv9b9NpEypPHiifA7pEXkoI5twdi5l+c1UoT1wfOojl6/sC
         KDg7useG/F0mxhcViwuAcqCDWVm15GmVyEZD0TTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 31/32] cgroup, netclassid: remove double cond_resched
Date:   Fri,  8 May 2020 14:35:44 +0200
Message-Id: <20200508123039.570048930@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 526f3d96b8f83b1b13d73bd0b5c79cc2c487ec8e upstream.

Commit 018d26fcd12a ("cgroup, netclassid: periodically release file_lock
on classid") added a second cond_resched to write_classid indirectly by
update_classid_task. Remove the one in write_classid.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/netclassid_cgroup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -131,10 +131,8 @@ static int write_classid(struct cgroup_s
 	cs->classid = (u32)value;
 
 	css_task_iter_start(css, 0, &it);
-	while ((p = css_task_iter_next(&it))) {
+	while ((p = css_task_iter_next(&it)))
 		update_classid_task(p, cs->classid);
-		cond_resched();
-	}
 	css_task_iter_end(&it);
 
 	return 0;


