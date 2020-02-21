Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C4F1672AC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbgBUIFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731845AbgBUIFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECF92222C4;
        Fri, 21 Feb 2020 08:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272338;
        bh=idBDqzu2y3o0QPiMY39TEUWKHEZlHWZnr1qSgzMQ1lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGj4lty5ufKxA1XYmT40vHoQ2GvOtUHJMde98JIkb1ubLUfvswVbJo3gIqRFpSaGp
         2AWmR4PFKWtlnckRpLkJo/SCQ0xZ/2BR+F5lnY/l5Fn+Dvy0tuM3Ny/CuUQwCA5qM7
         BhG4bYBc1EUilbUJXz30Zdnp4hU1n7ZUk7VMxrPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/344] udf: Allow writing to Rewritable partitions
Date:   Fri, 21 Feb 2020 08:37:48 +0100
Message-Id: <20200221072355.267881947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 15fb05fd286ac57a0802d71624daeb5c1c2d5b07 ]

UDF 2.60 standard states in section 2.2.14.2:

    A partition with Access Type 3 (rewritable) shall define a Freed
    Space Bitmap or a Freed Space Table, see 2.3.3. All other partitions
    shall not define a Freed Space Bitmap or a Freed Space Table.

    Rewritable partitions are used on media that require some form of
    preprocessing before re-writing data (for example legacy MO). Such
    partitions shall use Access Type 3.

    Overwritable partitions are used on media that do not require
    preprocessing before overwriting data (for example: CD-RW, DVD-RW,
    DVD+RW, DVD-RAM, BD-RE, HD DVD-Rewritable). Such partitions shall
    use Access Type 4.

however older versions of the standard didn't have this wording and
there are tools out there that create UDF filesystems with rewritable
partitions but that don't contain a Freed Space Bitmap or a Freed Space
Table on media that does not require pre-processing before overwriting a
block. So instead of forcing media with rewritable partition read-only,
base this decision on presence of a Freed Space Bitmap or a Freed Space
Table.

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Fixes: b085fbe2ef7f ("udf: Fix crash during mount")
Link: https://lore.kernel.org/linux-fsdevel/20200112144735.hj2emsoy4uwsouxz@pali
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8c28e93e9b730..008bf96b1732d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1035,7 +1035,6 @@ static int check_partition_desc(struct super_block *sb,
 	switch (le32_to_cpu(p->accessType)) {
 	case PD_ACCESS_TYPE_READ_ONLY:
 	case PD_ACCESS_TYPE_WRITE_ONCE:
-	case PD_ACCESS_TYPE_REWRITABLE:
 	case PD_ACCESS_TYPE_NONE:
 		goto force_ro;
 	}
-- 
2.20.1



