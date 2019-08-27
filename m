Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7269F9DFDA
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbfH0H6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbfH0H6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6723720828;
        Tue, 27 Aug 2019 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892686;
        bh=tpTGIhEqxp+KBGaDmFcATKiHYBPcEXPJInHvTwLE9V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CccCQxZCTrYk8I2ZjEUMThGYwfsnSf6qOQQ1Mb7AcdOq7ZcYKQo1PF4uGhpW4/v5Q
         47EUdOEGYQvawoLdIWFA2ZwvjKqO+d1YwIZqlTCUDBL9+lhWRYq+WVphtbANiEtQzl
         HIid7JRObAjiq5jglJLx6nq8Z5LcYHfSA+0WIETo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 78/98] dm raid: add missing cleanup in raid_ctr()
Date:   Tue, 27 Aug 2019 09:50:57 +0200
Message-Id: <20190827072722.218327181@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit dc1a3e8e0cc6b2293b48c044710e63395aeb4fb4 upstream.

If rs_prepare_reshape() fails, no cleanup is executed, leading to
leak of the raid_set structure allocated at the beginning of
raid_ctr(). To fix this issue, go to the label 'bad' if the error
occurs.

Fixes: 11e4723206683 ("dm raid: stop keeping raid set frozen altogether")
Cc: stable@vger.kernel.org
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3199,7 +3199,7 @@ static int raid_ctr(struct dm_target *ti
 			  */
 			r = rs_prepare_reshape(rs);
 			if (r)
-				return r;
+				goto bad;
 
 			/* Reshaping ain't recovery, so disable recovery */
 			rs_setup_recovery(rs, MaxSector);


