Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B96C15E4A7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405716AbgBNQXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405712AbgBNQXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCF8D24780;
        Fri, 14 Feb 2020 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697426;
        bh=oJIxZBnIPTrvFZMJWGftWgbdI8DB2FTc8wGJBaTBGP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPsdEWCDBllBI/rERYFjoOmRkPVh3hcmyi8s5/D5z7C3jXpYY2NIbMh7IdSqeHXS3
         GnwI7m5GKUs2XRwy1Z/c1GlWzRVjZgnmcXiDHo8bDffWb+3VFPtW2ZdaR77krQeJjS
         IxFybGyCrA2eTpwswHbed51PHIlEbF/oJWtFwz9c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 115/141] char: hpet: Use flexible-array member
Date:   Fri, 14 Feb 2020 11:20:55 -0500
Message-Id: <20200214162122.19794-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 987f028b8637cfa7658aa456ae73f8f21a7a7f6f ]

Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
presence of a "variable length array":

struct something {
    int length;
    u8 data[1];
};

struct something *instance;

instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
instance->length = size;
memcpy(instance->data, source, size);

There is also 0-byte arrays. Both cases pose confusion for things like
sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
to declare variable-length types such as the one above is a flexible array
member[2] which need to be the last member of a structure and empty-sized:

struct something {
        int stuff;
        u8 data[];
};

Also, by making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
unadvertenly introduced[3] to the codebase from now on.

[1] https://github.com/KSPP/linux/issues/21
[2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Link: https://lore.kernel.org/r/20200120235326.GA29231@embeddedor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hpet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index bedfd2412ec19..abbfc147980db 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -112,7 +112,7 @@ struct hpets {
 	unsigned long hp_delta;
 	unsigned int hp_ntimer;
 	unsigned int hp_which;
-	struct hpet_dev hp_dev[1];
+	struct hpet_dev hp_dev[];
 };
 
 static struct hpets *hpets;
-- 
2.20.1

