Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DEE26928E
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgINRIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgINNFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E71221E8;
        Mon, 14 Sep 2020 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088658;
        bh=Jpe/rsiCKdJ+48KmWbLzJ516lNH8QOlSQzvgrTbxLCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL/NwceA+CG1dMb1qB61ueAG2GGo+z5MKuTaRLFyFknVQS/KUEfaB6KsgNAfkUMIT
         Tvhb5/VTycf0MWCNJnvX9HvbPedQ9au+MDk94CvfgmklkFL83iJIaBy7S+4k0N/t3j
         I9ZSl0igkH6+NCoU9EsFfa3+lcNMTPufTBzRYww8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 17/29] kobject: Drop unneeded conditional in __kobject_del()
Date:   Mon, 14 Sep 2020 09:03:46 -0400
Message-Id: <20200914130358.1804194-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 07ecc6693f9157cf293da5d165c73fb28fd69bf4 ]

__kobject_del() is called from two places, in one where kobj is dereferenced
before and thus can't be NULL, and in the other the NULL check is done before
call. Drop unneeded conditional in __kobject_del().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200803083520.5460-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 3afb939f2a1cc..3a255f14e263e 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -604,9 +604,6 @@ static void __kobject_del(struct kobject *kobj)
 	struct kernfs_node *sd;
 	const struct kobj_type *ktype;
 
-	if (!kobj)
-		return;
-
 	sd = kobj->sd;
 	ktype = get_ktype(kobj);
 
-- 
2.25.1

