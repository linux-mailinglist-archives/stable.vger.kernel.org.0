Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B099A2268A0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgGTQIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgGTQIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D5E20734;
        Mon, 20 Jul 2020 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261326;
        bh=bHelhK3clDn+qoCr3rSYuH+TCTiDqOABSBHwl2bweWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVJXlGm1zfOaHe/lsS6Zn0lvluRXdhl/u3Tdo5CMBNnxdo8RXlJneqI9WgaamFqz7
         3Mvd93ga4eCF5HOppapiVLGHI0cOhmnChYAT6/2krDEKiarlZBaNJlNGVf+T0JdAyQ
         gqrmEHlItC5ZGSb48c7FrxsSw8bM/P4Y/fuBHO/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marshall Midden <marshallmidden@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 045/244] cifs: prevent truncation from long to int in wait_for_free_credits
Date:   Mon, 20 Jul 2020 17:35:16 +0200
Message-Id: <20200720152828.000688742@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 19e888678bac8c82206eb915eaf72741b2a2615c ]

The wait_event_... defines evaluate to long so we should not assign it an int as this may truncate
the value.

Reported-by: Marshall Midden <marshallmidden@gmail.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index c97570eb2c180..7fefd2bd111c4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -528,7 +528,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		      const int timeout, const int flags,
 		      unsigned int *instance)
 {
-	int rc;
+	long rc;
 	int *credits;
 	int optype;
 	long int t;
-- 
2.25.1



