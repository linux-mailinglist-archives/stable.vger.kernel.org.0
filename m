Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6F02E9A0F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbhADQCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728830AbhADQCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05FC222581;
        Mon,  4 Jan 2021 16:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776129;
        bh=Fc/qL3k89Pq9zdUYsw2qNJY+gjmXvKz4E+sYqzPlT2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIuh6IyTPPpANV1qRUYZFVHjX0zlWUN3T/QXfSgJt3iMtP9ynoGfA3CXflTrcxfLP
         00VYWL488mdHpycREWS1gu4aqh5flJ+km4O3xoAMNGQb0UM3SktulkwkAQGQcpyTMA
         uHgssuzPB8rh43rE0WS5dQnQPgDH1axrYQMJRqhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+96523fb438937cd01220@syzkaller.appspotmail.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 04/63] ethtool: fix string set id check
Date:   Mon,  4 Jan 2021 16:56:57 +0100
Message-Id: <20210104155709.020311198@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit efb796f5571f030743e1d9c662cdebdad724f8c5 ]

Syzbot reported a shift of a u32 by more than 31 in strset_parse_request()
which is undefined behavior. This is caused by range check of string set id
using variable ret (which is always 0 at this point) instead of id (string
set id from request).

Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Reported-by: syzbot+96523fb438937cd01220@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/r/b54ed5c5fd972a59afea3e1badfb36d86df68799.1607952208.git.mkubecek@suse.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/strset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -182,7 +182,7 @@ static int strset_parse_request(struct e
 		ret = strset_get_id(attr, &id, extack);
 		if (ret < 0)
 			return ret;
-		if (ret >= ETH_SS_COUNT) {
+		if (id >= ETH_SS_COUNT) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "unknown string set id");
 			return -EOPNOTSUPP;


