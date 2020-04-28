Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82361BCB2E
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgD1SzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729834AbgD1Scj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFBAF21707;
        Tue, 28 Apr 2020 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098758;
        bh=18SqyrRZK49Qas3xT+Wf30YPs7zYAKq0d/e1dxS3KiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rleCxTpB1Z682itU8AaS07S43MAWxOTwMMohCaVPg8RqJMmLP0+n994yx0JBhxWCS
         CCqbWkT56Rqnzf6dRqAaARDhMIs4Sm7dLRizPoyf0oPe6S6lhSyMT6DY28se2S330k
         ygUElfL0Yr5PM3T+2ZsrFXAFEGa3sUKA1YyFqJoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/131] kconfig: qconf: Fix a few alignment issues
Date:   Tue, 28 Apr 2020 20:23:55 +0200
Message-Id: <20200428182228.012367284@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 60969f02f07ae1445730c7b293c421d179da729c ]

There are a few items with wrong alignments. Solve them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index ef4310f2558b1..8f004db6f6034 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -627,7 +627,7 @@ void ConfigList::updateMenuList(ConfigItem *parent, struct menu* menu)
 			last = item;
 			continue;
 		}
-	hide:
+hide:
 		if (item && item->menu == child) {
 			last = parent->firstChild();
 			if (last == item)
@@ -692,7 +692,7 @@ void ConfigList::updateMenuList(ConfigList *parent, struct menu* menu)
 			last = item;
 			continue;
 		}
-	hide:
+hide:
 		if (item && item->menu == child) {
 			last = (ConfigItem*)parent->topLevelItem(0);
 			if (last == item)
@@ -1225,10 +1225,11 @@ QMenu* ConfigInfoView::createStandardContextMenu(const QPoint & pos)
 {
 	QMenu* popup = Parent::createStandardContextMenu(pos);
 	QAction* action = new QAction("Show Debug Info", popup);
-	  action->setCheckable(true);
-	  connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
-	  connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
-	  action->setChecked(showDebug());
+
+	action->setCheckable(true);
+	connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
+	connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
+	action->setChecked(showDebug());
 	popup->addSeparator();
 	popup->addAction(action);
 	return popup;
-- 
2.20.1



