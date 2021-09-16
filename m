Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DDC40E83C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353045AbhIPRoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354957AbhIPRkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205C161353;
        Thu, 16 Sep 2021 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811108;
        bh=ivWUIrP4TuiJfnMUxAyYeeKjiNltqZdsaKrlp+KtZ4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGWz6n2FvYl8u2U0dRdSl6+DJlEq7bGkAcvlaY8hepWRtijvra7ZwO8vebMX5DzhI
         vE+A1mCB5yVBZYoP10khkCkOTLUm/JkeBjANrj4YYBJd4iFFzhIoZwlZJMIJRkKzu8
         XOC5kQ4md7DmhMc9iPbGdFYkF8LGDSF+KerGm790=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 387/432] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Thu, 16 Sep 2021 18:02:16 +0200
Message-Id: <20210916155823.932585609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit e842cb60e8ac1d8a15b01e0dd4dad453807a597d ]

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when doi_def->type got value 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen in similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_cipso_v4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 000bb3da4f77..894e6b8f1a86 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -144,8 +144,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		return -ENOMEM;
 	doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
 	if (doi_def->map.std == NULL) {
-		ret_val = -ENOMEM;
-		goto add_std_failure;
+		kfree(doi_def);
+		return -ENOMEM;
 	}
 	doi_def->type = CIPSO_V4_MAP_TRANS;
 
-- 
2.30.2



