Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1046F3F54D0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhHXA4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhHXAzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DBBF6142A;
        Tue, 24 Aug 2021 00:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766499;
        bh=KBtAVMP+VFpQhLREu6k36qT5cu56hxJkOwhYETtEKyw=;
        h=From:To:Cc:Subject:Date:From;
        b=NdImHMosDdf3a0pYgbCrVeBweSR+Lop/Bg7EOzDRd3Wnxs4rwzXA9EJhxQg8EG2aT
         cRyIL0Sz0xVRlPu5QEoQFDUhf/Q0uKZnSyhbINXFhxD8Sk4at1J+Si00aPljPEwGWM
         upBXIyHAf2a4D3zYcbfV7B48IviUXimSr4ht6lhMef8sydhGQ26c3SZ3emC0f8fK+j
         +oxSc5yOejKjWBCFQpcr0NY1g1zd1tyF2+7AkL9kBt3Oqt8e+vu4O36vJ3Qcp6F70Q
         qLWtbQ7w1rJmtU4mFkVb7Jb7QMq1jU5fzMrRciNR3xaUodvz9K+T8xSKlGmvw6BOx+
         P2s8pkEZqs0XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/10] opp: remove WARN when no valid OPPs remain
Date:   Mon, 23 Aug 2021 20:54:48 -0400
Message-Id: <20210824005458.631377-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 335ffab3ef864539e814b9a2903b0ae420c1c067 ]

This WARN can be triggered per-core and the stack trace is not useful.
Replace it with plain dev_err(). Fix a comment while at it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 249738e1e0b7..603c688fe23d 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -682,8 +682,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto remove_static_opp;
 	}
-- 
2.30.2

