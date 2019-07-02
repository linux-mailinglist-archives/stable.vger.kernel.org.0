Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545425CBEC
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGBICq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfGBICq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4D3216C8;
        Tue,  2 Jul 2019 08:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054565;
        bh=l38vMRgwQYIAowAjhEHFO5/jEsKo8inoBgrQgGayZSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIDgWmeZ50eXlgPbMSBheKChSI4rUCkOwRu6UThSXnw8Icmy1DCgYG4afIEnIC6Ll
         rLEZYgECQtvMnkvtlE83nbAPkFWQbJerhP64nJIyRoccgQ7RMZ1mKiJLg4W6bL6yzj
         oAcRZatYE+jLw7wSMI/4VqwUvXO6FYdOcs5u8seQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@kernel.org>,
        Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>,
        "Chen, Jerry T" <jerry.t.chen@intel.com>,
        "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 13/55] mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fails
Date:   Tue,  2 Jul 2019 10:01:21 +0200
Message-Id: <20190702080124.727361433@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit b38e5962f8ed0d2a2b28a887fc2221f7f41db119 upstream.

The pass/fail of soft offline should be judged by checking whether the
raw error page was finally contained or not (i.e.  the result of
set_hwpoison_free_buddy_page()), but current code do not work like
that.  It might lead us to misjudge the test result when
set_hwpoison_free_buddy_page() fails.

Without this fix, there are cases where madvise(MADV_SOFT_OFFLINE) may
not offline the original page and will not return an error.

Link: http://lkml.kernel.org/r/1560154686-18497-2-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>
Cc: "Chen, Jerry T" <jerry.t.chen@intel.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1733,6 +1733,8 @@ static int soft_offline_huge_page(struct
 		if (!ret) {
 			if (set_hwpoison_free_buddy_page(page))
 				num_poisoned_pages_inc();
+			else
+				ret = -EBUSY;
 		}
 	}
 	return ret;


