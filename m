Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D955B2A51BD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgKCUne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgKCUna (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869DF223BD;
        Tue,  3 Nov 2020 20:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436210;
        bh=BQYu1YTg3tcxOcZFF2iWnqggeA1yrU7gdHcB1aPN8Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onfzoDOZxFSuoDLnFTwM+8j9jDDvtZQ8PL8pfpgsDibrDiuSvV+bb+PMnGU4Ex2hv
         gsxFq/+9uFXPaclmt9hKgHhRnIlKEFMi3ApPyIaqXWrIeFjUJq4Q8USeFcWlfIx47J
         dg23CyScc0abNUUyhsX9naYyy2TtFGQFrUaPwwOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 151/391] net: 9p: initialize sun_server.sun_path to have addrs value only when addr is valid
Date:   Tue,  3 Nov 2020 21:33:22 +0100
Message-Id: <20201103203357.021299616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 7ca1db21ef8e0e6725b4d25deed1ca196f7efb28 ]

In p9_fd_create_unix, checking is performed to see if the addr (passed
as an argument) is NULL or not.
However, no check is performed to see if addr is a valid address, i.e.,
it doesn't entirely consist of only 0's.
The initialization of sun_server.sun_path to be equal to this faulty
addr value leads to an uninitialized variable, as detected by KMSAN.
Checking for this (faulty addr) and returning a negative error number
appropriately, resolves this issue.

Link: http://lkml.kernel.org/r/20201012042404.2508-1-anant.thazhemadam@gmail.com
Reported-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Tested-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c0762a302162c..8f528e783a6c5 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1023,7 +1023,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
 
 	csocket = NULL;
 
-	if (addr == NULL)
+	if (!addr || !strlen(addr))
 		return -EINVAL;
 
 	if (strlen(addr) >= UNIX_PATH_MAX) {
-- 
2.27.0



