Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0BACE31
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfIHMy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732693AbfIHMvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:37 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8C820693;
        Sun,  8 Sep 2019 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947097;
        bh=IqEauNs7qeUy74R3qRiokvDUb9O7TGDvPagbktP5iyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wudm01kpAa9u3eVm5n6yX5CuWtG2uxJENHDEkZyz+1MafKCNT0AB15c5Dqi4ln+fD
         +MndrkVlhBFRpXDJGBB0Xamg53bSrnafXRBQc4pmcHRMhKIIpaXE7cinAxoociKieH
         43MqbP/w5mDnEbqxcilb0kXTgrnRJy6/tMJ5H5TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 61/94] wimax/i2400m: fix a memory leak bug
Date:   Sun,  8 Sep 2019 13:41:57 +0100
Message-Id: <20190908121152.178684260@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 44ef3a03252844a8753479b0cea7f29e4a804bdc ]

In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
to hold the original command line options. Then, the options are parsed.
However, if an error occurs during the parsing process, 'options_orig' is
not deallocated, leading to a memory leak bug. To fix this issue, free
'options_orig' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wimax/i2400m/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index e9fc168bb7345..489cba9b284d1 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -351,13 +351,15 @@ int i2400m_barker_db_init(const char *_options)
 			}
 			result = i2400m_barker_db_add(barker);
 			if (result < 0)
-				goto error_add;
+				goto error_parse_add;
 		}
 		kfree(options_orig);
 	}
 	return 0;
 
+error_parse_add:
 error_parse:
+	kfree(options_orig);
 error_add:
 	kfree(i2400m_barker_db);
 	return result;
-- 
2.20.1



