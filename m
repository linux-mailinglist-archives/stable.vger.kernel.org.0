Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C478F4061AC
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhIJAn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhIJATI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DD1611C5;
        Fri, 10 Sep 2021 00:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233077;
        bh=u+flZvOYWGNKFD+suWRBjayVX7zt509XcX5zvOGHEC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0B98daE5V/MAC9HTFcQyMKvC2fwox0bMfEbhE517tihUQV9wPMbSVW65Gof6fMyY
         DiI36iBe+tbkz5tZHIdH1t9bcjKyxOLVwYIBF6o9Hqy1lVm+Tnyxua/IbKimSP8hFT
         yyd1/UDqgPFUfoW35ASpRhbTlIst6ABlzRVj2wKmOTpGuTyWC0rDViqfZBgn0mxqzA
         9HC9C/BKqtOr/8K6rN5uh91PfXPDs61RJKH2/yp+6S/xx/Ka2IPMWmQcwrndS3g2Fg
         Nq+yWV6Z7Dzd5Y7mPiHnahoDg30HENoVAM5MU7zlZlGHh7fwgIcufLpMFSXWWtjaRn
         YXfcyk+HfzH+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Chris Mackowski <cmackows@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.14 86/99] fs: dlm: avoid comms shutdown delay in release_lockspace
Date:   Thu,  9 Sep 2021 20:15:45 -0400
Message-Id: <20210910001558.173296-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit ecd95673142ef80169a6c003b569b8a86d1e6329 ]

When dlm_release_lockspace does active shutdown on connections to
other nodes, the active shutdown will wait for any exisitng passive
shutdowns to be resolved.  But, the sequence of operations during
dlm_release_lockspace can prevent the normal resolution of passive
shutdowns (processed normally by way of lockspace recovery.)
This disruption of passive shutdown handling can cause the active
shutdown to wait for a full timeout period, delaying the completion
of dlm_release_lockspace.

To fix this, make dlm_release_lockspace resolve existing passive
shutdowns (by calling dlm_clear_members earlier), before it does
active shutdowns.  The active shutdowns will not find any passive
shutdowns to wait for, and will not be delayed.

Reported-by: Chris Mackowski <cmackows@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index d71aba8c3e64..e51ae83fc5b4 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -793,6 +793,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	if (ls_count == 1) {
 		dlm_scand_stop();
+		dlm_clear_members(ls);
 		dlm_midcomms_shutdown();
 	}
 
-- 
2.30.2

