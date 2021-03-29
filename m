Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1502134CA14
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhC2Ieu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234748AbhC2Idf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A5E161601;
        Mon, 29 Mar 2021 08:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006805;
        bh=zV74FDpV7KdgKP8lu0FW+fH5DmD7xWIndgTpypGpvAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpRMVHUQO4M/dD2J7IYuoreysjE01CT8X+ajBniZS/wIwTEmumHy08OXYw//E1MnA
         F3V3JYCNlIHFFJPRrMQlmM+Gaaiw8OS90Je+kI02Z9MIwOX/HL54rrCFmi0RmdX6dp
         52R/U5v2LDxr/nlijAzEN75BvrGOFA1+mM/ssgHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 104/254] dm: dont report "detected capacity change" on device creation
Date:   Mon, 29 Mar 2021 09:57:00 +0200
Message-Id: <20210329075636.620321082@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5424a0b867e65f1ecf34ffe88d091a4fcbb35bc1 upstream.

When a DM device is first created it doesn't yet have an established
capacity, therefore the use of set_capacity_and_notify() should be
conditional given the potential for needless pr_info "detected
capacity change" noise even if capacity is 0.

One could argue that the pr_info() in set_capacity_and_notify() is
misplaced, but that position is not held uniformly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f64d9b2eacb9 ("dm: use set_capacity_and_notify")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2016,7 +2016,10 @@ static struct dm_table *__bind(struct ma
 	if (size != dm_get_size(md))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	set_capacity_and_notify(md->disk, size);
+	if (!get_capacity(md->disk))
+		set_capacity(md->disk, size);
+	else
+		set_capacity_and_notify(md->disk, size);
 
 	dm_table_event_callback(t, event_callback, md);
 


