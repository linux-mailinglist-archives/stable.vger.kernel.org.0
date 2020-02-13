Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC94415C55B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbgBMPZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387483AbgBMPZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:40 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C5F24693;
        Thu, 13 Feb 2020 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607539;
        bh=QU5hlEcn8A5qyauh+f5DdOPlzw74Il9ZLeMFavcEx8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiHcqdUr9OTviKbiQSWHnqTR9HzmRE59Df2WkGe5DhBADZlL+x/3Wuy7IS9ki/jgr
         LE9uP3Hzyf90drwACldYYL1GnYZHop2RMfDpNq9PhhXrdvU0B9OOdE7qDDUfy0SL1n
         1fNuc9FSgC2rFooNDGam+t4XCCAAI/bXH7VC928w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.14 108/173] ubi: fastmap: Fix inverted logic in seen selfcheck
Date:   Thu, 13 Feb 2020 07:20:11 -0800
Message-Id: <20200213151959.862589401@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit ef5aafb6e4e9942a28cd300bdcda21ce6cbaf045 upstream.

set_seen() sets the bit corresponding to the PEB number in the bitmap,
so when self_check_seen() wants to find PEBs that haven't been seen we
have to print the PEBs that have their bit cleared, not the ones which
have it set.

Fixes: 5d71afb00840 ("ubi: Use bitmaps in Fastmap self-check code")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/fastmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -73,7 +73,7 @@ static int self_check_seen(struct ubi_de
 		return 0;
 
 	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
-		if (test_bit(pnum, seen) && ubi->lookuptbl[pnum]) {
+		if (!test_bit(pnum, seen) && ubi->lookuptbl[pnum]) {
 			ubi_err(ubi, "self-check failed for PEB %d, fastmap didn't see it", pnum);
 			ret = -EINVAL;
 		}


