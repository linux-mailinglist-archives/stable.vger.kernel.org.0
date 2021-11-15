Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1A5451EF3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347908AbhKPAiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344601AbhKOTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20B1863351;
        Mon, 15 Nov 2021 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002836;
        bh=uHCj75hZer4672laXv6y7zpKRVUwgAOF3sGQXiueWRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0MreAlAMwXpaFrBFSARmnYLU4+ISIMTJ5cdKbrFpaE10dIYwqcv7wuZxRFSeSDKp
         51/JkT3ucBRU0GZUMfAajTYVCYblGCYSe7EIQPyOFvtXxjwPuZ2vp01znnUx81fKXM
         Rd2HSYJMCvxHxIY3Ihg5cY+4GO7MN6RL+0EnZAJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 715/917] opp: Fix return in _opp_add_static_v2()
Date:   Mon, 15 Nov 2021 18:03:30 +0100
Message-Id: <20211115165453.141321651@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 27ff8187f13ecfec8a26fb1928e906f46f326cc5 ]

Fix sparse warning:
drivers/opp/of.c:924 _opp_add_static_v2() warn: passing zero to 'ERR_PTR'

For duplicate OPPs 'ret' be set to zero.

Fixes: deac8703da5f ("PM / OPP: _of_add_opp_table_v2(): increment count only if OPP is added")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 2a97c6535c4c6..c32ae7497392b 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -921,7 +921,7 @@ free_required_opps:
 free_opp:
 	_opp_free(new_opp);
 
-	return ERR_PTR(ret);
+	return ret ? ERR_PTR(ret) : NULL;
 }
 
 /* Initializes OPP tables based on new bindings */
-- 
2.33.0



