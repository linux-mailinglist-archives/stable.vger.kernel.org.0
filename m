Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E724F568
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgHXIsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbgHXIsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968EF204FD;
        Mon, 24 Aug 2020 08:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258917;
        bh=zPyi0lwUhPMnBc/9pj7LVqMKNRCt13Zbze66ujo7f6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCWThFmGevj4VzaUzHtQEWngJsbHYhk4n1xUFLEW4r30DWuoDYMm8Iww9Unh61fvD
         Ie6oRRKbxOW1QFegDrNEjFgU6GOaLhtsTkalxlLVSmvh3/SgIiqR9GtzEebKWOHilc
         CyEVXvWLEMWdxPnQXBTOraGEPQKq9/iBsN6unPmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/107] kconfig: qconf: fix signal connection to invalid slots
Date:   Mon, 24 Aug 2020 10:30:57 +0200
Message-Id: <20200824082409.611267844@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d85de3399f97467baa2026fbbbe587850d01ba8a ]

If you right-click in the ConfigList window, you will see the following
messages in the console:

QObject::connect: No such slot QAction::setOn(bool) in scripts/kconfig/qconf.cc:888
QObject::connect:  (sender name:   'config')
QObject::connect: No such slot QAction::setOn(bool) in scripts/kconfig/qconf.cc:897
QObject::connect:  (sender name:   'config')
QObject::connect: No such slot QAction::setOn(bool) in scripts/kconfig/qconf.cc:906
QObject::connect:  (sender name:   'config')

Right, there is no such slot in QAction. I think this is a typo of
setChecked.

Due to this bug, when you toggled the menu "Option->Show Name/Range/Data"
the state of the context menu was not previously updated. Fix this.

Fixes: d5d973c3f8a9 ("Port xconfig to Qt5 - Put back some of the old implementation(part 2)")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 3e7fbfae798c2..a94909ad9a53a 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -878,7 +878,7 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
 		connect(action, SIGNAL(toggled(bool)),
 			parent(), SLOT(setShowName(bool)));
 		connect(parent(), SIGNAL(showNameChanged(bool)),
-			action, SLOT(setOn(bool)));
+			action, SLOT(setChecked(bool)));
 		action->setChecked(showName);
 		headerPopup->addAction(action);
 
@@ -887,7 +887,7 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
 		connect(action, SIGNAL(toggled(bool)),
 			parent(), SLOT(setShowRange(bool)));
 		connect(parent(), SIGNAL(showRangeChanged(bool)),
-			action, SLOT(setOn(bool)));
+			action, SLOT(setChecked(bool)));
 		action->setChecked(showRange);
 		headerPopup->addAction(action);
 
@@ -896,7 +896,7 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
 		connect(action, SIGNAL(toggled(bool)),
 			parent(), SLOT(setShowData(bool)));
 		connect(parent(), SIGNAL(showDataChanged(bool)),
-			action, SLOT(setOn(bool)));
+			action, SLOT(setChecked(bool)));
 		action->setChecked(showData);
 		headerPopup->addAction(action);
 	}
@@ -1228,7 +1228,7 @@ QMenu* ConfigInfoView::createStandardContextMenu(const QPoint & pos)
 
 	action->setCheckable(true);
 	connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
-	connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
+	connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setChecked(bool)));
 	action->setChecked(showDebug());
 	popup->addSeparator();
 	popup->addAction(action);
-- 
2.25.1



