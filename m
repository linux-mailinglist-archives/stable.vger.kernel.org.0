Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9686524F49B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgHXIiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbgHXIiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:38:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE992177B;
        Mon, 24 Aug 2020 08:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258293;
        bh=9W0Ya6Gt65VYCcjU3mitmvFQa1ldn5Bt82bw6ASrcjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yscEc30mbCA4jLtRWDdoYM9k+lQHnNP57VnrCVi0LYc9nQUKDl2aXJspzBBhhQGXV
         zpJ4H9eEWoZQeNFDLVZiunnqBsmzfbhI8cd4zqhmb95tF7v0JVN4Btf3DH05J3FlS6
         J45z5Z9uyhqv+aHIpatHkWqX8nQGsaV6ZI0aUoEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 118/148] kconfig: qconf: do not limit the pop-up menu to the first row
Date:   Mon, 24 Aug 2020 10:30:16 +0200
Message-Id: <20200824082419.664536136@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit fa8de0a3bf3c02e6f00b7746e7e934db522cdda9 ]

If you right-click the first row in the option tree, the pop-up menu
shows up, but if you right-click the second row or below, the event
is ignored due to the following check:

  if (e->y() <= header()->geometry().bottom()) {

Perhaps, the intention was to show the pop-menu only when the tree
header was right-clicked, but this handler is not called in that case.

Since the origin of e->y() starts from the bottom of the header,
this check is odd.

Going forward, you can right-click anywhere in the tree to get the
pop-up menu.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 68 ++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 23d1cb01a41ae..be67e74237d22 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -864,40 +864,40 @@ void ConfigList::focusInEvent(QFocusEvent *e)
 
 void ConfigList::contextMenuEvent(QContextMenuEvent *e)
 {
-	if (e->y() <= header()->geometry().bottom()) {
-		if (!headerPopup) {
-			QAction *action;
-
-			headerPopup = new QMenu(this);
-			action = new QAction("Show Name", this);
-			  action->setCheckable(true);
-			  connect(action, SIGNAL(toggled(bool)),
-				  parent(), SLOT(setShowName(bool)));
-			  connect(parent(), SIGNAL(showNameChanged(bool)),
-				  action, SLOT(setOn(bool)));
-			  action->setChecked(showName);
-			  headerPopup->addAction(action);
-			action = new QAction("Show Range", this);
-			  action->setCheckable(true);
-			  connect(action, SIGNAL(toggled(bool)),
-				  parent(), SLOT(setShowRange(bool)));
-			  connect(parent(), SIGNAL(showRangeChanged(bool)),
-				  action, SLOT(setOn(bool)));
-			  action->setChecked(showRange);
-			  headerPopup->addAction(action);
-			action = new QAction("Show Data", this);
-			  action->setCheckable(true);
-			  connect(action, SIGNAL(toggled(bool)),
-				  parent(), SLOT(setShowData(bool)));
-			  connect(parent(), SIGNAL(showDataChanged(bool)),
-				  action, SLOT(setOn(bool)));
-			  action->setChecked(showData);
-			  headerPopup->addAction(action);
-		}
-		headerPopup->exec(e->globalPos());
-		e->accept();
-	} else
-		e->ignore();
+	if (!headerPopup) {
+		QAction *action;
+
+		headerPopup = new QMenu(this);
+		action = new QAction("Show Name", this);
+		action->setCheckable(true);
+		connect(action, SIGNAL(toggled(bool)),
+			parent(), SLOT(setShowName(bool)));
+		connect(parent(), SIGNAL(showNameChanged(bool)),
+			action, SLOT(setOn(bool)));
+		action->setChecked(showName);
+		headerPopup->addAction(action);
+
+		action = new QAction("Show Range", this);
+		action->setCheckable(true);
+		connect(action, SIGNAL(toggled(bool)),
+			parent(), SLOT(setShowRange(bool)));
+		connect(parent(), SIGNAL(showRangeChanged(bool)),
+			action, SLOT(setOn(bool)));
+		action->setChecked(showRange);
+		headerPopup->addAction(action);
+
+		action = new QAction("Show Data", this);
+		action->setCheckable(true);
+		connect(action, SIGNAL(toggled(bool)),
+			parent(), SLOT(setShowData(bool)));
+		connect(parent(), SIGNAL(showDataChanged(bool)),
+			action, SLOT(setOn(bool)));
+		action->setChecked(showData);
+		headerPopup->addAction(action);
+	}
+
+	headerPopup->exec(e->globalPos());
+	e->accept();
 }
 
 ConfigView*ConfigView::viewList;
-- 
2.25.1



