Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11ACD27C32C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgI2LDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728494AbgI2LDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:03:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C4421734;
        Tue, 29 Sep 2020 11:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377424;
        bh=n3hmtfD59C4ems+rZxUHWhFLOpK8I3eT4DA6XNIj3ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYkrcwqwD8vhlSqjyUKeataXffKgSIr1CV6k+1Le8Es9plo8eb5hqetlkuNihqPW3
         JRa09NIOC5zcB4Rj5AwCvEqr26hQvDpy/lWs/pAJQlqym0YnDfA4M4gCJRko0lNUvw
         CNJ0PzJ8HYt9yILCKPlhPAOJhuX0CFlHymFMPf3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        "Nobuhiro Iwamatsu (CIP)" <noburhio1.nobuhiro@toshiba.co.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/85] mtd: Fix comparison in map_word_andequal()
Date:   Tue, 29 Sep 2020 12:59:33 +0200
Message-Id: <20200929105928.531686550@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit ea739a287f4f16d6250bea779a1026ead79695f2 upstream.

Commit 9e343e87d2c4 ("mtd: cfi: convert inline functions to macros")
changed map_word_andequal() into a macro, but also changed the right
hand side of the comparison from val3 to val2.  Change it back to use
val3 on the right hand side.

Thankfully this did not cause a regression because all callers
currently pass the same argument for val2 and val3.

Fixes: 9e343e87d2c4 ("mtd: cfi: convert inline functions to macros")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <noburhio1.nobuhiro@toshiba.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/map.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 676d3d2a1a0a9..d8bae7cb86f39 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -307,7 +307,7 @@ void map_destroy(struct mtd_info *mtd);
 ({									\
 	int i, ret = 1;							\
 	for (i = 0; i < map_words(map); i++) {				\
-		if (((val1).x[i] & (val2).x[i]) != (val2).x[i]) {	\
+		if (((val1).x[i] & (val2).x[i]) != (val3).x[i]) {	\
 			ret = 0;					\
 			break;						\
 		}							\
-- 
2.25.1



