Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AA1E2BA9
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389914AbgEZTHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391592AbgEZTHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3295B208C3;
        Tue, 26 May 2020 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520038;
        bh=2Tli62SHDhwS8tdWOatrxO8zwH2xSPs+kFNRaMlgpUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CupP2sgvEPOSpAktoByJsa5hGwha1nUWlrdVCL3BBeEMpbJVGfwXhflrhnPFYiOu4
         w+IMBVW1j8OL1p17cKI6mHtXOweG1U7njY921O3/dNhcideA+wPXhWC5KCpHTxqLt+
         zoJc6RmpmRD36Az/EoYJbKHUue3cVJKpxaxVFbI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Macieira <thiago.macieira@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, stable@kernel.org
Subject: [PATCH 5.4 009/111] fix multiplication overflow in copy_fdtable()
Date:   Tue, 26 May 2020 20:52:27 +0200
Message-Id: <20200526183933.400536287@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 4e89b7210403fa4a8acafe7c602b6212b7af6c3b ]

cpy and set really should be size_t; we won't get an overflow on that,
since sysctl_nr_open can't be set above ~(size_t)0 / sizeof(void *),
so nr that would've managed to overflow size_t on that multiplication
won't get anywhere near copy_fdtable() - we'll fail with EMFILE
before that.

Cc: stable@kernel.org # v2.6.25+
Fixes: 9cfe015aa424 (get rid of NR_OPEN and introduce a sysctl_nr_open)
Reported-by: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 3da91a112bab..e5d328335f88 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -70,7 +70,7 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
  */
 static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 {
-	unsigned int cpy, set;
+	size_t cpy, set;
 
 	BUG_ON(nfdt->max_fds < ofdt->max_fds);
 
-- 
2.25.1



