Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6E21E2E13
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391394AbgEZTEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390877AbgEZTEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DF720873;
        Tue, 26 May 2020 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519882;
        bh=36qQNXW0vrV1cpauf0h8+fAq47FTsFqzhPggG0em0tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFjzTiwgzIZilijDB2bJwtBLk0Nx0gb+L0+O7FxOpkdfoMoH3Sg0/lW76gGrEfAeS
         2/zFsNJVlCbofUB1ooaltPECsD2XB2eiaOd87Y8PWnm+xjiednG9Watn0YypdYteVI
         K4VDVxfNnXQChgqHK+G96sIs7+NKmqz57NbtcrGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/81] libnvdimm/btt: Remove unnecessary code in btt_freelist_init
Date:   Tue, 26 May 2020 20:53:27 +0200
Message-Id: <20200526183932.900018493@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 2f8c9011151337d0bc106693f272f9bddbccfab2 ]

We call btt_log_read() twice, once to get the 'old' log entry, and again
to get the 'new' entry. However, we have no use for the 'old' entry, so
remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/btt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 75ae2c508a04..d78cfe82ad5c 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -541,9 +541,9 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 
 static int btt_freelist_init(struct arena_info *arena)
 {
-	int old, new, ret;
+	int new, ret;
 	u32 i, map_entry;
-	struct log_entry log_new, log_old;
+	struct log_entry log_new;
 
 	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
@@ -551,10 +551,6 @@ static int btt_freelist_init(struct arena_info *arena)
 		return -ENOMEM;
 
 	for (i = 0; i < arena->nfree; i++) {
-		old = btt_log_read(arena, i, &log_old, LOG_OLD_ENT);
-		if (old < 0)
-			return old;
-
 		new = btt_log_read(arena, i, &log_new, LOG_NEW_ENT);
 		if (new < 0)
 			return new;
-- 
2.25.1



