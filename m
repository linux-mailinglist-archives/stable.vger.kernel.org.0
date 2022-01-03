Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA3B483593
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiACR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiACR2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073AAC061761;
        Mon,  3 Jan 2022 09:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84AB0B80E66;
        Mon,  3 Jan 2022 17:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F787C36AEB;
        Mon,  3 Jan 2022 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230932;
        bh=zw1NdbOtkyijo7fXN+XvLZTKIYt/6pYw8B0XdMToLBU=;
        h=From:To:Cc:Subject:Date:From;
        b=NQfiROXpLiIqG0IxOaTU5uq8Qi1snYHst6D9tJdAEZvQ6dbu+T9rIPqaHBSHVprTQ
         nAVAAsw++k1DTAm3gL0gzL3aI2uBBqMliXqPygsOPgqdlsuMzEIHbs+yGKSbCGpduL
         8IOrlsHBzLUimq1jjpr9BrVp9ywjoNggfL9y+kQV1wt9Dg1th4J4MxbeJq0wTPdP4l
         Nz/AqOpgGxNMQhX7tNPMdsHFV77XTFXtkQ2OoHvfXuaAYaR0lSONEqj4hAjIJMGeA6
         0NLsLQcI9zG3hyZo2mrQGqW/E9cvM5HfVrxjU24LawpOzQPtuP6S5Gvbx8Rb14zkLW
         RrxkmS+eQ9jng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Sampaio <sampaio.ime@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 01/16] auxdisplay: charlcd: checking for pointer reference before dereferencing
Date:   Mon,  3 Jan 2022 12:28:34 -0500
Message-Id: <20220103172849.1612731-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Sampaio <sampaio.ime@gmail.com>

[ Upstream commit 4daa9ff89ef27be43c15995412d6aee393a78200 ]

Check if the pointer lcd->ops->init_display exists before dereferencing it.
If a driver called charlcd_init() without defining the ops, this would
return segmentation fault, as happened to me when implementing a charlcd
driver.  Checking the pointer before dereferencing protects from
segmentation fault.

Signed-off-by: Luiz Sampaio <sampaio.ime@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/charlcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 304accde365c8..6c010d4efa4ae 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -578,6 +578,9 @@ static int charlcd_init(struct charlcd *lcd)
 	 * Since charlcd_init_display() needs to write data, we have to
 	 * enable mark the LCD initialized just before.
 	 */
+	if (WARN_ON(!lcd->ops->init_display))
+		return -EINVAL;
+
 	ret = lcd->ops->init_display(lcd);
 	if (ret)
 		return ret;
-- 
2.34.1

