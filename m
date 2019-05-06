Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB9114F59
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfEFOeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfEFOeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66CE7204EC;
        Mon,  6 May 2019 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153261;
        bh=dI8Maplq9wgE1ui3lywvel+oaZ9IBkGVBTdYHYdlJvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RK4egXBQ18m36GGrvOCFgDFJa+8qU5+aN+N/1ozmqVQ9DaZxYXLi/kCCwrYXM+ZW9
         Aq4Z5p3wbYQkYMMLrsktt2TRrYO/fkSflgxu0+oV+K4z6Uh0bYdKue1aEQVpuUaaS+
         MIydr/a5jeu2bNDUEtjsuxTcjplhRWdttTevN9rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4ece1a28b8f4730547c9@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.0 007/122] mac80211: dont attempt to rename ERR_PTR() debugfs dirs
Date:   Mon,  6 May 2019 16:31:05 +0200
Message-Id: <20190506143055.370026142@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 517879147493a5e1df6b89a50f708f1133fcaddb upstream.

We need to dereference the directory to get its parent to
be able to rename it, so it's clearly not safe to try to
do this with ERR_PTR() pointers. Skip in this case.

It seems that this is most likely what was causing the
report by syzbot, but I'm not entirely sure as it didn't
come with a reproducer this time.

Cc: stable@vger.kernel.org
Reported-by: syzbot+4ece1a28b8f4730547c9@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/debugfs_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -841,7 +841,7 @@ void ieee80211_debugfs_rename_netdev(str
 
 	dir = sdata->vif.debugfs_dir;
 
-	if (!dir)
+	if (IS_ERR_OR_NULL(dir))
 		return;
 
 	sprintf(buf, "netdev:%s", sdata->name);


