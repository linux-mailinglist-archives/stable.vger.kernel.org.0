Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4C13E4BE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389903AbgAPRKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389900AbgAPRKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F5921D56;
        Thu, 16 Jan 2020 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194619;
        bh=ul71Y/zEbW7xkWlk/aceUw/nzMusboXygjav+Ia0Llo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNrGCXyZOfUNa7q0ntGnXKruh+BdC5lwrn3Z4Dppf7DFZmrlfvPHnqF1yJvnQF5GL
         FoMhaonFjL018f8lEaq9IgFu6yhwFyrK6NBJnynqzBoaFg7oku5P/jYtSQ0tw042yD
         wU6y6lKKJuk1SJ8dcE5UG30qG1vyKNG1DX/PdpU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 481/671] cifs: fix rmmod regression in cifs.ko caused by force_sig changes
Date:   Thu, 16 Jan 2020 12:01:59 -0500
Message-Id: <20200116170509.12787-218-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 247bc9470b1eeefc7b58cdf2c39f2866ba651509 ]

Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")

The global change from force_sig caused module unloading of cifs.ko
to fail (since the cifsd process could not be killed, "rmmod cifs"
now would always fail)

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a59dcda07534..a8790bf04e95 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -970,6 +970,7 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
 	set_freezable();
+	allow_signal(SIGKILL);
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
-- 
2.20.1

