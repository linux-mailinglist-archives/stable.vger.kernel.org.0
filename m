Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED82D87A0
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439351AbgLLQJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439333AbgLLQIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:08:50 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 04/23] dm integrity: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Sat, 12 Dec 2020 11:07:45 -0500
Message-Id: <20201212160804.2334982-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a7a10bce8a04f48238a8306ec97d430b77917015 ]

Don't use crypto drivers that have the flag CRYPTO_ALG_ALLOCATES_MEMORY
set. These drivers allocate memory and thus they are not suitable for
block I/O processing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 3fc3757def55e..5a7a1b90e671c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3462,7 +3462,7 @@ static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
 	int r;
 
 	if (a->alg_string) {
-		*hash = crypto_alloc_shash(a->alg_string, 0, 0);
+		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(*hash)) {
 			*error = error_alg;
 			r = PTR_ERR(*hash);
@@ -3519,7 +3519,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 		struct journal_completion comp;
 
 		comp.ic = ic;
-		ic->journal_crypt = crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, 0);
+		ic->journal_crypt = crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(ic->journal_crypt)) {
 			*error = "Invalid journal cipher";
 			r = PTR_ERR(ic->journal_crypt);
-- 
2.27.0

