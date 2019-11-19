Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9158F101812
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfKSFej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbfKSFei (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B41208C3;
        Tue, 19 Nov 2019 05:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141678;
        bh=djqdZXlQ3iLn+R5cPJY6lBtwWI+0PBuh+RGdpxjWQW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfqscCqfTI+O3T0VNKb2Im/2Hfa0r+y+fkGswlIVhxggbTGeWgpo/PHuDTvOws92Y
         dgq9NfUSoUQUhXUankT7vYhK3RR3ew3sv+i2LO+9gmFbEATOY//arccliB3+qX976m
         KrGpzeNSjDSqDQixaqvkDOTwUy6QZLVGjU3mPw2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Banajit Goswami <bgoswami@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 226/422] component: fix loop condition to call unbind() if bind() fails
Date:   Tue, 19 Nov 2019 06:17:03 +0100
Message-Id: <20191119051413.281574543@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Banajit Goswami <bgoswami@codeaurora.org>

[ Upstream commit bdae566d5d9733b6e32b378668b84eadf28a94d4 ]

During component_bind_all(), if bind() fails for any
particular component associated with a master, unbind()
should be called for all previous components in that
master's match array, whose bind() might have completed
successfully. As per the current logic, if bind() fails
for the component at position 'n' in the master's match
array, it would start calling unbind() from component in
'n'th position itself and work backwards, and will always
skip calling unbind() for component in 0th position in the
master's match array.
Fix this by updating the loop condition, and the logic to
refer to the components in master's match array, so that
unbind() is called for all components starting from 'n-1'st
position in the array, until (and including) component in
0th position.

Signed-off-by: Banajit Goswami <bgoswami@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/component.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 8946dfee4768e..e8d676fad0c95 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -536,9 +536,9 @@ int component_bind_all(struct device *master_dev, void *data)
 		}
 
 	if (ret != 0) {
-		for (; i--; )
-			if (!master->match->compare[i].duplicate) {
-				c = master->match->compare[i].component;
+		for (; i > 0; i--)
+			if (!master->match->compare[i - 1].duplicate) {
+				c = master->match->compare[i - 1].component;
 				component_unbind(c, master, data);
 			}
 	}
-- 
2.20.1



