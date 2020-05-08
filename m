Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B7E1CACE6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgEHM4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgEHM4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:56:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9792054F;
        Fri,  8 May 2020 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942572;
        bh=Afv2FaG5DQaHqoUBgBp0RuCQ3U8KX62WJDiJFCsqfJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOwSX04aU0Efwu06TnzBvAt0xyDXYo1z5uGX3fCVpo+JBWBR0uZaD0XQz7aWrFUVt
         mfSDJYW/b0758+PKpBeNp2z+CvTTq5WyQD905QIy45a4DdWhgNRxkguTOOzGx/UwXV
         XharQXwr1vItIRQTCoL5isy5f6DzwpsO+6gbn32g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 48/49] cgroup, netclassid: remove double cond_resched
Date:   Fri,  8 May 2020 14:36:05 +0200
Message-Id: <20200508123049.452001905@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
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
@@ -127,10 +127,8 @@ static int write_classid(struct cgroup_s
 	cs->classid = (u32)value;
 
 	css_task_iter_start(css, 0, &it);
-	while ((p = css_task_iter_next(&it))) {
+	while ((p = css_task_iter_next(&it)))
 		update_classid_task(p, cs->classid);
-		cond_resched();
-	}
 	css_task_iter_end(&it);
 
 	return 0;


