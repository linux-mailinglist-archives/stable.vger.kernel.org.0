Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3E45BD8C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243545AbhKXMjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344468AbhKXMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:36:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CB136120A;
        Wed, 24 Nov 2021 12:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756528;
        bh=fKa8rAAyooEbN40y1+yfnuGUfr9qBhlVmquhIExR30w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDXaKQPJ909PQtT6qli1XeUTI3v0BfihuS0oPej0YzI6yzK01Gh0Oe/QNRP6H6FjF
         lvpZaJaX9d/ac4u3wnvqXSPjECA62HCh5SVMJD8Ct41DLfkNFypLf6I263LDMNpIiP
         zCNm7jSkxeviOSLog2VPgJbQrzIIflgMTiiT12z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/251] memstick: avoid out-of-range warning
Date:   Wed, 24 Nov 2021 12:56:00 +0100
Message-Id: <20211124115714.331662477@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 22de7f5ed0323..ffe8757406713 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1730,7 +1730,7 @@ static int msb_init_card(struct memstick_dev *card)
 	msb->pages_in_block = boot_block->attr.block_size * 2;
 	msb->block_size = msb->page_size * msb->pages_in_block;
 
-	if (msb->page_size > PAGE_SIZE) {
+	if ((size_t)msb->page_size > PAGE_SIZE) {
 		/* this isn't supported by linux at all, anyway*/
 		dbg("device page %d size isn't supported", msb->page_size);
 		return -EINVAL;
-- 
2.33.0



