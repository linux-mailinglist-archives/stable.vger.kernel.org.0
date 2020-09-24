Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063C276E14
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 12:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIXKBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 06:01:15 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:51966 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIXKBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 06:01:15 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 08OA11GR025727; Thu, 24 Sep 2020 19:01:01 +0900
X-Iguazu-Qid: 2wHHWkRyd75cutEjQ0
X-Iguazu-QSIG: v=2; s=0; t=1600941660; q=2wHHWkRyd75cutEjQ0; m=BF8o1VAC+j9JfB+gfUQkwCt6SD05lcph2ZL5dRZIZnY=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 08OA0v2x037051;
        Thu, 24 Sep 2020 19:00:58 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 08OA0vPG017684;
        Thu, 24 Sep 2020 19:00:57 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 08OA0vKr007861;
        Thu, 24 Sep 2020 19:00:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Nobuhiro Iwamatsu <noburhio1.nobuhiro@toshiba.co.jp>
Subject: [PATCH for 4.4 and 4.9] mtd: Fix comparison in map_word_andequal()
Date:   Thu, 24 Sep 2020 19:00:54 +0900
X-TSB-HOP: ON
Message-Id: <20200924100054.367518-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
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
---
 include/linux/mtd/map.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index b5b43f94f31162..01b990e4b228a9 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -312,7 +312,7 @@ void map_destroy(struct mtd_info *mtd);
 ({									\
 	int i, ret = 1;							\
 	for (i = 0; i < map_words(map); i++) {				\
-		if (((val1).x[i] & (val2).x[i]) != (val2).x[i]) {	\
+		if (((val1).x[i] & (val2).x[i]) != (val3).x[i]) {	\
 			ret = 0;					\
 			break;						\
 		}							\
--
2.28.0

