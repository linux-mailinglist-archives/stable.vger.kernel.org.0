Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB773A02B4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhFHTHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237884AbhFHTGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A99CE613E3;
        Tue,  8 Jun 2021 18:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178011;
        bh=b52sEY+tkE+gRi8XHbjW662W7eLb5zPRI+YYfrH0Bos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VG5BqfETgmf3j0YFhjrnTL4ct+oPO0bSOxpswcQqVQP9+y70bdor8/Vflj9GzCmPn
         I3nY6pfP9fJ2iN0moa2wFd7FFKT4XWn0eHdP/uLuuDVtcL0mpn4qoRZnOllXGzjF4h
         sc2PkNJmMUtq30SRokiSes+IRGTmLr3NPoQdAPJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 042/161] drm/i915/selftests: Fix return value check in live_breadcrumbs_smoketest()
Date:   Tue,  8 Jun 2021 20:26:12 +0200
Message-Id: <20210608175946.889579331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 10c1f0cbcea93beec5d3bdc02b1a3b577b4985e7 ]

In case of error, the function live_context() returns ERR_PTR() and never
returns NULL. The NULL test in the return value check should be replaced
with IS_ERR().

Fixes: 52c0fdb25c7c ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/33c46ef24cd547d0ad21dc106441491a@intel.com
[tursulin: Wrap commit text, fix Fixes: tag.]
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
(cherry picked from commit 8f4caef8d5401b42c6367d46c23da5e0e8111516)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_request.c b/drivers/gpu/drm/i915/selftests/i915_request.c
index d2a678a2497e..411494005f0e 100644
--- a/drivers/gpu/drm/i915/selftests/i915_request.c
+++ b/drivers/gpu/drm/i915/selftests/i915_request.c
@@ -1392,8 +1392,8 @@ static int live_breadcrumbs_smoketest(void *arg)
 
 	for (n = 0; n < smoke[0].ncontexts; n++) {
 		smoke[0].contexts[n] = live_context(i915, file);
-		if (!smoke[0].contexts[n]) {
-			ret = -ENOMEM;
+		if (IS_ERR(smoke[0].contexts[n])) {
+			ret = PTR_ERR(smoke[0].contexts[n]);
 			goto out_contexts;
 		}
 	}
-- 
2.30.2



