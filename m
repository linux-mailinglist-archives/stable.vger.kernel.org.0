Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB111D8536
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgERR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731722AbgERR46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 460D520674;
        Mon, 18 May 2020 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824617;
        bh=/yFRTgkjOjuakAcUHMYNBsrRG7i5WsGSgwVe2mmzVsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXZRYEWhr8KJ3mQh1BfLmnE1jiZJ+dAMYvGTNdOms8+6Vvu0+PQdsWKYpahireXc3
         5syekWbpv3XVLG2A8RkxQFWu2ZEHE2CxMzvQDbCoDFCxtqZF0CCsik4jY2qw2MVowL
         W0iKIWu0VzIj5rzQLSlkZXLRHlZ2ie4Scz8iY+I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Minet <v.minet@criteo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 036/147] umh: fix memory leak on execve failure
Date:   Mon, 18 May 2020 19:35:59 +0200
Message-Id: <20200518173518.608541981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Minet <v.minet@criteo.com>

[ Upstream commit db803036ada7d61d096783726f9771b3fc540370 ]

If a UMH process created by fork_usermode_blob() fails to execute,
a pair of struct file allocated by umh_pipe_setup() will leak.

Under normal conditions, the caller (like bpfilter) needs to manage the
lifetime of the UMH and its two pipes. But when fork_usermode_blob()
fails, the caller doesn't really have a way to know what needs to be
done. It seems better to do the cleanup ourselves in this case.

Fixes: 449325b52b7a ("umh: introduce fork_usermode_blob() helper")
Signed-off-by: Vincent Minet <v.minet@criteo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/umh.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -475,6 +475,12 @@ static void umh_clean_and_save_pid(struc
 {
 	struct umh_info *umh_info = info->data;
 
+	/* cleanup if umh_pipe_setup() was successful but exec failed */
+	if (info->pid && info->retval) {
+		fput(umh_info->pipe_to_umh);
+		fput(umh_info->pipe_from_umh);
+	}
+
 	argv_free(info->argv);
 	umh_info->pid = info->pid;
 }


