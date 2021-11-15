Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42E4522C4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377934AbhKPBQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244489AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B9F563412;
        Mon, 15 Nov 2021 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000502;
        bh=uHCj75hZer4672laXv6y7zpKRVUwgAOF3sGQXiueWRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2F21Rn0uVyUAzg+ib4mY2HrAbq/TPVvuwnMwnJ1+uLzrCIO67zdwfvRWM59/Ssohy
         0KSx9+BhIrevYittKE7sd1fuzYYlR6q3xO+3L1ypsM9w7LQ4Z6hx8kN1xzVu2w4d4c
         YWFNrr/465ctHPl6fXqYHBPyp9rrrKJCO0fS8vOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 684/849] opp: Fix return in _opp_add_static_v2()
Date:   Mon, 15 Nov 2021 18:02:47 +0100
Message-Id: <20211115165443.407560273@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



