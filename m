Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50311134BD
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfLDR7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbfLDR7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:09 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A4220675;
        Wed,  4 Dec 2019 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482348;
        bh=ZKAtWUsN0FqEAoJtA7XbheslHWVtULPIZOm3hQjh9nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eroMLjeCcYsUQK7qkF+z1luC2HIE1CMjfYolYS0qYGnj10OTuvOH01M2sOEzZHpTR
         cxAr9+Be9E5TMKs88YpPK7jx5hLMsGaZA4RiI8aqq2tGiRR8E4U9sD+hyOg2CCEV0t
         nLhjC/elQ/iTBvD2BAMfiwRH+T+5IG8FY4F+GyFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Roland Kammerer <roland.kammerer@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 52/92] drbd: fix print_st_err()s prototype to match the definition
Date:   Wed,  4 Dec 2019 18:49:52 +0100
Message-Id: <20191204174333.587453832@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

[ Upstream commit 2c38f035117331eb78d0504843c79ea7c7fabf37 ]

print_st_err() is defined with its 4th argument taking an
'enum drbd_state_rv' but its prototype use an int for it.

Fix this by using 'enum drbd_state_rv' in the prototype too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_state.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 7f53c40823cd5..75219cd2534aa 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -126,7 +126,7 @@ extern enum drbd_state_rv __drbd_set_state(struct drbd_device *, union drbd_stat
 					   enum chg_state_flags,
 					   struct completion *done);
 extern void print_st_err(struct drbd_device *, union drbd_state,
-			union drbd_state, int);
+			union drbd_state, enum drbd_state_rv);
 
 enum drbd_state_rv
 _conn_request_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
-- 
2.20.1



