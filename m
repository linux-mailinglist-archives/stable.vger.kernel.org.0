Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5580528915
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403764AbfEWTak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403787AbfEWTak (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19BD821855;
        Thu, 23 May 2019 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639839;
        bh=GS0tX16/BUOw5pgwhsBCxb0NVNf2p/tJmSBmNjtGIHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nP9QjqrVImWFczYj1Nr5iV5e9hbLSJzdKoRq8cxtnV+c/uhULrSsC1dM2UvLfoV1I
         dJISPueTFllDb3sJwLQdhEGhZM0B7NfW5Ppr4hPn6wKXjfvN0Z1QpsQiW2fTfnaHip
         6RsnaxZP6dQ2vmVyhJuYsfV4lp6himkskkHWo2uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Lass <bevan@bi-co.net>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 111/122] dm: make sure to obey max_io_len_target_boundary
Date:   Thu, 23 May 2019 21:07:13 +0200
Message-Id: <20190523181720.134658446@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Lass <bevan@bi-co.net>

commit 51b86f9a8d1c4bb4e3862ee4b4c5f46072f7520d upstream.

Commit 61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM
target interface") incorrectly removed code from
__send_changing_extent_only() that is required to impose a per-target IO
boundary on IO that exceeds max_io_len_target_boundary().  Otherwise
"special" IO (e.g. DISCARD, WRITE SAME, WRITE ZEROES) can write beyond
where allowed.

Fix this by restoring the max_io_len_target_boundary() limit in
__send_changing_extent_only()

Fixes: 61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM target interface")
Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Michael Lass <bevan@bi-co.net>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1467,7 +1467,7 @@ static unsigned get_num_write_zeroes_bio
 static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
 				       unsigned num_bios)
 {
-	unsigned len = ci->sector_count;
+	unsigned len;
 
 	/*
 	 * Even though the device advertised support for this type of
@@ -1478,6 +1478,8 @@ static int __send_changing_extent_only(s
 	if (!num_bios)
 		return -EOPNOTSUPP;
 
+	len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+
 	__send_duplicate_bios(ci, ti, num_bios, &len);
 
 	ci->sector += len;


