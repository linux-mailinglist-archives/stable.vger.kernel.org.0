Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA4F2D5E12
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391167AbgLJOik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387712AbgLJOib (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.9 43/75] dm writecache: advance the number of arguments when reporting max_age
Date:   Thu, 10 Dec 2020 15:27:08 +0100
Message-Id: <20201210142608.187980683@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit e5d41cbca1b2036362c9e29d705d3a175a01eff8 upstream.

When reporting the "max_age" value the number of arguments must
advance by two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 3923d4854e18 ("dm writecache: implement gradual cleanup")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2479,6 +2479,8 @@ static void writecache_status(struct dm_
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
+		if (wc->max_age != MAX_AGE_UNSPECIFIED)
+			extra_args += 2;
 		if (wc->cleaner)
 			extra_args++;
 		if (wc->writeback_fua_set)


