Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FFD408EFA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbhIMNi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhIMNgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2129613A7;
        Mon, 13 Sep 2021 13:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539669;
        bh=CPT4ZBiULuw3xhdWyYmp8eWV+zgr5iLX8NgXvtBw9Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+SS1gie+MLPH+k6oKVo3RCTPVcIYQJjRYd9Z0CzrB2T2Sn5KPwIvgIbJHxgsoY4T
         24j+mpr8AmorMJSxIqNSDwWkr8fs98o3drzVdpt4iQulSI/FQqS2MjjYlAq7RjrJAN
         5bCN/Ifetqx7tKPzjrb6jd2E57VrZY+3Ha6uXmxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Subject: [PATCH 5.10 114/236] net: cipso: fix warnings in netlbl_cipsov4_add_std
Date:   Mon, 13 Sep 2021 15:13:39 +0200
Message-Id: <20210913131104.222949345@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 8ca34a13f7f9b3fa2c464160ffe8cc1a72088204 ]

Syzbot reported warning in netlbl_cipsov4_add(). The
problem was in too big doi_def->map.std->lvl.local_size
passed to kcalloc(). Since this value comes from userpace there is
no need to warn if value is not correct.

The same problem may occur with other kcalloc() calls in
this function, so, I've added __GFP_NOWARN flag to all
kcalloc() calls there.

Reported-and-tested-by: syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Fixes: 96cb8e3313c7 ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_cipso_v4.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 4f50a64315cf..50f40943c815 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -187,14 +187,14 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 	doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.local == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
 	}
 	doi_def->map.std->lvl.cipso = kcalloc(doi_def->map.std->lvl.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.cipso == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
@@ -263,7 +263,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.local = kcalloc(
 					      doi_def->map.std->cat.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.local == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
@@ -271,7 +271,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.cipso = kcalloc(
 					      doi_def->map.std->cat.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.cipso == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
-- 
2.30.2



