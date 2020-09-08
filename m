Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A478E26198B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgIHSUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731313AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0E72475D;
        Tue,  8 Sep 2020 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579697;
        bh=mGXVqNlMsEZaGyBVqwlJTei7oBHIO/a7GkgRWLH8YRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQ7Gz1EBJdOxm4Od9+FV9rYjEL1fajisgOhsMiYMHo4KqLy3uYx+XoNICpedQ1Td6
         iJ9Ah+mo+RXUzbdo/69az3AGDrKPQFgyt1w5f1UZ9VR1OuxUPRe/3ticx8chYN9jxz
         Nx8ZRqf2Udef2rbR9ItawBFMin+mpxQ6AqFSy5QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d451401ffd00a60677ee@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.8 185/186] cfg80211: regulatory: reject invalid hints
Date:   Tue,  8 Sep 2020 17:25:27 +0200
Message-Id: <20200908152250.639747428@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 47caf685a6854593348f216e0b489b71c10cbe03 upstream.

Reject invalid hints early in order to not cause a kernel
WARN later if they're restored to or similar.

Reported-by: syzbot+d451401ffd00a60677ee@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d451401ffd00a60677ee
Link: https://lore.kernel.org/r/20200819084648.13956-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2944,6 +2944,9 @@ int regulatory_hint_user(const char *alp
 	if (WARN_ON(!alpha2))
 		return -EINVAL;
 
+	if (!is_world_regdom(alpha2) && !is_an_alpha2(alpha2))
+		return -EINVAL;
+
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;


