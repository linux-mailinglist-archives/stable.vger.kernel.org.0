Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988C1147DD5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbgAXKDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:03:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbgAXKD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:03:29 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2272206D5;
        Fri, 24 Jan 2020 10:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860208;
        bh=PPmiJew4ZvvOF6Bm7FQ3PW4vL2IOrlK99XR0eg3zSKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuTs6pNbFJ3h6o66DK4wy9pohWuR5Vq8Gu8TPAiHOjshVjJG8QXruHtjgXKW8nJUm
         I62LfhxM9v9PMVs+8jVxsJkBYSvyOB9HKgWZ2OvAA6CG4bZyS8aoSSNYJLGsUdL7Tl
         VjjUU/OCUy1FwPQUpyJqLQ1wTtOtt7eqZTqcx43M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 267/343] cifs: fix rmmod regression in cifs.ko caused by force_sig changes
Date:   Fri, 24 Jan 2020 10:31:25 +0100
Message-Id: <20200124092955.105191282@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 51bbb1c0b71ae..ed4a0352ea90e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -921,6 +921,7 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
 	set_freezable();
+	allow_signal(SIGKILL);
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
-- 
2.20.1



