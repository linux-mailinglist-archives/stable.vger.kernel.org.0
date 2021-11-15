Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98136450DED
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239814AbhKOSJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239721AbhKOSEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D11EF63272;
        Mon, 15 Nov 2021 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997908;
        bh=5D1esiNiNzWYgkuB/GBXzeWLfcYRQ/HtFAFcME/XTTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJw/XcLDmtvoOmep+YgVl3ms7bilGMTJcru9e3eGxCPzy1UgFq/HMWr9QmTV9Jj1c
         qjwKdnUUwI7xIW5kJpcim2HSH9hagyKUTx0hXKkvM8szVmyfqQ3XeFVh2oQPVZNgQK
         rDDnYxTAMgcxfezrJ5uanepqpPdlSGzLdKAfxqcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/575] memstick: avoid out-of-range warning
Date:   Mon, 15 Nov 2021 18:00:42 +0100
Message-Id: <20211115165354.758623143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4853396f03c3019eccf5cd113e464231e9ddf0b3 ]

clang-14 complains about a sanity check that always passes when the
page size is 64KB or larger:

drivers/memstick/core/ms_block.c:1739:21: error: result of comparison of constant 65536 with expression of type 'unsigned short' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (msb->page_size > PAGE_SIZE) {
            ~~~~~~~~~~~~~~ ^ ~~~~~~~~~

This is fine, it will still work on all architectures, so just shut
up that warning with a cast.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210927094520.696665-1-arnd@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 8004dd64d09a8..bc1f484f50f1d 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1727,7 +1727,7 @@ static int msb_init_card(struct memstick_dev *card)
 	msb->pages_in_block = boot_block->attr.block_size * 2;
 	msb->block_size = msb->page_size * msb->pages_in_block;
 
-	if (msb->page_size > PAGE_SIZE) {
+	if ((size_t)msb->page_size > PAGE_SIZE) {
 		/* this isn't supported by linux at all, anyway*/
 		dbg("device page %d size isn't supported", msb->page_size);
 		return -EINVAL;
-- 
2.33.0



