Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528881990E7
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgCaJPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgCaJPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A64CE20787;
        Tue, 31 Mar 2020 09:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646140;
        bh=4QJEQOKZynqx+5osBx7WAdPupqu0Gs4IifljY4vX/rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gg9EtJr4ywHBIbMEZonoOaTpzhs/I/IyXYTaAJ2+6soWyknTtcY+O0WjzLpWemkcR
         oevkOjqHlXxEi1tQ0uewt9z9TX/YyXraCSlpe/YQo/pnV/IHVWAvffgfbY2Crn00qU
         koPBWdw6G278Xo1QI5VwvNQ+gYpK6rpHn9wtpk/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Mueller <dmueller@suse.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 095/155] scripts/dtc: Remove redundant YYLOC global declaration
Date:   Tue, 31 Mar 2020 10:58:55 +0200
Message-Id: <20200331085429.266293703@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Mueller <dmueller@suse.com>

commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.

gcc 10 will default to -fno-common, which causes this error at link
time:

  (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here

This is because both dtc-lexer as well as dtc-parser define the same
global symbol yyloc. Before with -fcommon those were merged into one
defintion. The proper solution would be to to mark this as "extern",
however that leads to:

  dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
   26 | extern YYLTYPE yylloc;
      |                ^~~~~~
In file included from dtc-lexer.l:24:
dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
  127 | extern YYLTYPE yylloc;
      |                ^~~~~~
cc1: all warnings being treated as errors

which means the declaration is completely redundant and can just be
dropped.

Signed-off-by: Dirk Mueller <dmueller@suse.com>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
[robh: cherry-pick from upstream]
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/dtc/dtc-lexer.l |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -23,7 +23,6 @@ LINECOMMENT	"//".*\n
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */


