Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC6427280F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgIUOk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgIUOk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B391523888;
        Mon, 21 Sep 2020 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699256;
        bh=3wKhPCJK4e88PuLvX2Hp1ADWTWdm1mMqRIpGDGZjUag=;
        h=From:To:Cc:Subject:Date:From;
        b=prEX5My8a6UDJq2KfhZDacmShbvTu2g/0DTFx57j4nsBs5fm4FY6qshPhWGVl6jNP
         pB8S8ISXjBmGSxv1wg/lZPM7PV5NsGqVGv0gZuNjMuRiXl95ry+eZja0jwMH6Z9eIo
         I8ziqG3dBjYtvu/f6WO2EADVeTHIukAm/q/Iaurc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amol Grover <frextrite@gmail.com>,
        James Morris <jmorris@namei.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/15] device_cgroup: Fix RCU list debugging warning
Date:   Mon, 21 Sep 2020 10:40:40 -0400
Message-Id: <20200921144054.2135602-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

[ Upstream commit bc62d68e2a0a69fcdcf28aca8edb01abf306b698 ]

exceptions may be traversed using list_for_each_entry_rcu()
outside of an RCU read side critical section BUT under the
protection of decgroup_mutex. Hence add the corresponding
lockdep expression to fix the following false-positive
warning:

[    2.304417] =============================
[    2.304418] WARNING: suspicious RCU usage
[    2.304420] 5.5.4-stable #17 Tainted: G            E
[    2.304422] -----------------------------
[    2.304424] security/device_cgroup.c:355 RCU-list traversed in non-reader section!!

Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/device_cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 725674f3276d3..5d7bb91c64876 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -352,7 +352,8 @@ static bool match_exception_partial(struct list_head *exceptions, short type,
 {
 	struct dev_exception_item *ex;
 
-	list_for_each_entry_rcu(ex, exceptions, list) {
+	list_for_each_entry_rcu(ex, exceptions, list,
+				lockdep_is_held(&devcgroup_mutex)) {
 		if ((type & DEVCG_DEV_BLOCK) && !(ex->type & DEVCG_DEV_BLOCK))
 			continue;
 		if ((type & DEVCG_DEV_CHAR) && !(ex->type & DEVCG_DEV_CHAR))
-- 
2.25.1

