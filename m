Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6A272F2A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgIUQpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgIUQpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C5E92076B;
        Mon, 21 Sep 2020 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706740;
        bh=Ym6t0eaYuLupir2lStyz4Gr4PMkrUEHoS+dTrxBEu8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRSFkjBtB4SPpp46gxbXaonPP0w8LfkIIVmk9vw0crvp2hnMbpUt6yVjojj3gHfXw
         y73FwCf2vrOMz9MrQ4XHLMgBVhGvCM/3ImnXferIE8NikXo3SsSzNJ6nxj9Wg3NQWf
         ETDY9+ERZ+lEyi6kxvRdTxbGrGIVDBVkmKtCRWEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 075/118] kconfig: qconf: use delete[] instead of delete to free array (again)
Date:   Mon, 21 Sep 2020 18:28:07 +0200
Message-Id: <20200921162039.823243128@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a608b6a646e8816bc0db156baad2e0679fa4d137 ]

Commit c9b09a9249e6 ("kconfig: qconf: use delete[] instead of delete
to free array") fixed two lines, but there is one more.
(cppcheck does not report it for some reason...)

This was detected by Clang.

"make HOSTCXX=clang++ xconfig" reports the following:

scripts/kconfig/qconf.cc:1279:2: warning: 'delete' applied to a pointer that was allocated with 'new[]'; did you mean 'delete[]'? [-Wmismatched-new-delete]
        delete data;
        ^
              []
scripts/kconfig/qconf.cc:1239:15: note: allocated with 'new[]' here
        char *data = new char[count + 1];
                     ^

Fixes: c4f7398bee9c ("kconfig: qconf: make debug links work again")
Fixes: c9b09a9249e6 ("kconfig: qconf: use delete[] instead of delete to free array")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 5ceb93010a973..aedcc3343719e 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1263,7 +1263,7 @@ void ConfigInfoView::clicked(const QUrl &url)
 	}
 
 	free(result);
-	delete data;
+	delete[] data;
 }
 
 QMenu* ConfigInfoView::createStandardContextMenu(const QPoint & pos)
-- 
2.25.1



