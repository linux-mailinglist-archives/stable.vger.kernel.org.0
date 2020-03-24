Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452CE191109
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgCXNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgCXNNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F4820775;
        Tue, 24 Mar 2020 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055609;
        bh=NKO7/sy2SbHYRRuLnnyHaNYxduCv66hpOHZ2FY3V0lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnqCXdug2001lyGFZCvjp+PN96m4H5qHpQUdNqwdbKqcEiJNET0pkMCTv/4wWaBoJ
         AbK44MLP4/cNXxrBMMUwGEHKmPGU1qZD2O6uLJK8xGmnajZPosPA3beuUrc18ctpdm
         PqTE7cz+XLer3L30Rkt0m07HrKrvKQTpU45Ex5K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 38/65] staging: greybus: loopback_test: fix poll-mask build breakage
Date:   Tue, 24 Mar 2020 14:10:59 +0100
Message-Id: <20200324130802.026151828@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 8f3675be4bda33adbdc1dd2ab3b6c76a7599a79e upstream.

A scripted conversion from userland POLL* to kernel EPOLL* constants
mistakingly replaced the poll flags in the loopback_test tool, which
therefore no longer builds.

Fixes: a9a08845e9ac ("vfs: do bulk POLL* -> EPOLL* replacement")
Cc: stable <stable@vger.kernel.org>     # 4.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200312110151.22028-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/greybus/tools/loopback_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/greybus/tools/loopback_test.c
+++ b/drivers/staging/greybus/tools/loopback_test.c
@@ -663,7 +663,7 @@ static int open_poll_files(struct loopba
 			goto err;
 		}
 		read(t->fds[fds_idx].fd, &dummy, 1);
-		t->fds[fds_idx].events = EPOLLERR|EPOLLPRI;
+		t->fds[fds_idx].events = POLLERR | POLLPRI;
 		t->fds[fds_idx].revents = 0;
 		fds_idx++;
 	}
@@ -756,7 +756,7 @@ static int wait_for_complete(struct loop
 		}
 
 		for (i = 0; i < t->poll_count; i++) {
-			if (t->fds[i].revents & EPOLLPRI) {
+			if (t->fds[i].revents & POLLPRI) {
 				/* Dummy read to clear the event */
 				read(t->fds[i].fd, &dummy, 1);
 				number_of_events++;


