Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62434328C24
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbhCASqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234867AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D0464EF2;
        Mon,  1 Mar 2021 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621078;
        bh=z1uUYphWQyaAuJdnaeiW0jYDgrFF6UeV+hFvZYlHf+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvm+CsCuZf960+h8n6AGGdzmU+5EeZuD3Obdazhp0RN3su/g7vgRo4jZdoUPuhsvy
         SGCvCzpei28BLTolRFXipGYfnphNJrUss0TsQYe0hX18x/QGwYpPq6exWibN3GLjyl
         Ya0/mS3mRqRP14M5W33kTpNxFCjarsAQQ2f5FXyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 385/775] tools/testing/scatterlist: Fix overflow of max segment size
Date:   Mon,  1 Mar 2021 17:09:13 +0100
Message-Id: <20210301161220.630657927@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 96667052149da3855c4361925324b690c687152f ]

Because SCATTERLIST_MAX_SEGMENT was removed and replaced with UINT_MAX,
the test overflows the max_sgement variable. Remove this case.

Fixes: 7a60c2dd0f57 ("drm: Remove SCATTERLIST_MAX_SEGMENT")
Link: https://lore.kernel.org/r/20210125120527.836363-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/scatterlist/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/scatterlist/main.c b/tools/testing/scatterlist/main.c
index 71c960dcd8a42..652254754b4cb 100644
--- a/tools/testing/scatterlist/main.c
+++ b/tools/testing/scatterlist/main.c
@@ -55,7 +55,6 @@ int main(void)
 	struct test *test, tests[] = {
 		{ -EINVAL, 1, pfn(0), NULL, PAGE_SIZE, 0, 1 },
 		{ 0, 1, pfn(0), NULL, PAGE_SIZE, PAGE_SIZE + 1, 1 },
-		{ 0, 1, pfn(0), NULL, PAGE_SIZE, sgmax + 1, 1 },
 		{ 0, 1, pfn(0), NULL, PAGE_SIZE, sgmax, 1 },
 		{ 0, 1, pfn(0), NULL, 1, sgmax, 1 },
 		{ 0, 2, pfn(0, 1), NULL, 2 * PAGE_SIZE, sgmax, 1 },
-- 
2.27.0



