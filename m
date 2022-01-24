Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FD49A95A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322491AbiAYDVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52350 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383330AbiAXU1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6557F614EC;
        Mon, 24 Jan 2022 20:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492A8C340E5;
        Mon, 24 Jan 2022 20:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056028;
        bh=3bYJ1Uv45V46z7TGSRB+5GaY5VET5wRoQDd1kBkBs3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pYqU4GbYQCklm0JVshHrPvdC5ObQnmilOZhsFt8+n8xp8mNvil8EQyw1R6uNLj4s
         wrVyxXZU5OkTQhwUjTphcMstpX/4FytIRrIGXKo8hvPfXxkNnx0amdLE7sFL5NopD/
         qiMAZGnuccxmHHC9GEYMWj940aZw5391r3RaeRAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/846] lib/mpi: Add the return value check of kcalloc()
Date:   Mon, 24 Jan 2022 19:37:43 +0100
Message-Id: <20220124184112.880158506@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zizhuang Deng <sunsetdzz@gmail.com>

[ Upstream commit dd827abe296fe4249b2f8c9b95f72f814ea8348c ]

Add the return value check of kcalloc() to avoid potential
NULL ptr dereference.

Fixes: a8ea8bdd9df9 ("lib/mpi: Extend the MPI library")
Signed-off-by: Zizhuang Deng <sunsetdzz@gmail.com>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/mpi-mod.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/mpi/mpi-mod.c b/lib/mpi/mpi-mod.c
index 47bc59edd4ff9..54fcc01564d9d 100644
--- a/lib/mpi/mpi-mod.c
+++ b/lib/mpi/mpi-mod.c
@@ -40,6 +40,8 @@ mpi_barrett_t mpi_barrett_init(MPI m, int copy)
 
 	mpi_normalize(m);
 	ctx = kcalloc(1, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
 
 	if (copy) {
 		ctx->m = mpi_copy(m);
-- 
2.34.1



