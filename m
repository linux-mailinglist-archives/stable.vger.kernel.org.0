Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4691641728B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343872AbhIXMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343927AbhIXMsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD1AE61269;
        Fri, 24 Sep 2021 12:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487619;
        bh=8IVwMeb8ymQH5KAkXBE8Xq6RTl7VlhR4Um/qHv0R+ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnwGcQfcx0ia7ikfgNJVKbkIZINtTu4FyO7DyorEDGcYuHHfBTbiwezHSlWGJZSSI
         imXq+T1xaw3RafE75Y6wfboQcKPcueHJzbH7Ec6i77fCwxNeAzWEBXwyf65gOwO2Lo
         qPOcGlKS2v3arTM7prN8ONFsKNnX3HwKX20YuQiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn " <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 03/27] apparmor: remove duplicate macro list_entry_is_head()
Date:   Fri, 24 Sep 2021 14:43:57 +0200
Message-Id: <20210924124329.290625736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9801ca279ad37f72f71234fa81722afd95a3f997 upstream.

Strangely I hadn't had noticed the existence of the list_entry_is_head()
in apparmor code when added the same one in the list.h.  Luckily it's
fully identical and didn't break builds.  In any case we don't need a
duplicate anymore, thus remove it from apparmor code.

Link: https://lkml.kernel.org/r/20201208100639.88182-1-andriy.shevchenko@linux.intel.com
Fixes: e130816164e244 ("include/linux/list.h: add a macro to test if entry is pointing to the head")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn " <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/apparmorfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1900,9 +1900,6 @@ fail2:
 	return error;
 }
 
-
-#define list_entry_is_head(pos, head, member) (&pos->member == (head))
-
 /**
  * __next_ns - find the next namespace to list
  * @root: root namespace to stop search at (NOT NULL)


