Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F073949A045
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843622AbiAXXFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841841AbiAXXAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:00:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921F3C02B772;
        Mon, 24 Jan 2022 13:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F81C61469;
        Mon, 24 Jan 2022 21:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D70CC340E5;
        Mon, 24 Jan 2022 21:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058825;
        bh=3bYJ1Uv45V46z7TGSRB+5GaY5VET5wRoQDd1kBkBs3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cEO5oIXPGyqluOHowVogsRYyakTQUCtbOjf7RtCSG50pASGtT0RoAWtUdgJiJQWa
         AmOGofe0JomF33nDLZ+Eb1g7G8boNk5KMCfLzBqemOWL//8kxHaBpSN5G7tEaS9ZUv
         JTnNsY/glLTjC5aSqW7/bEzGVBBvH5ZcmL+ptECM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0415/1039] lib/mpi: Add the return value check of kcalloc()
Date:   Mon, 24 Jan 2022 19:36:44 +0100
Message-Id: <20220124184139.262102539@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



