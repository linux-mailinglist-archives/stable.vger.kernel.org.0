Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8C38EFA5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhEXP6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234501AbhEXP5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A515613D2;
        Mon, 24 May 2021 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871033;
        bh=p+L6IWdDWj3BuKlRYk3bfT3VrIjBfJfW1TbppQKKpR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5WdWmCwbw7M3eS+P248RRyqjTAHgYV+tskQap+Z18J6EhnDXKW4KmGsZC569utUw
         aXYfM6zr/VLAmWn3Kt8JtDdLAZQ7hXDgS4AZsAHvu2swqIflCKKbfnCqPGxtM8Ol9B
         GYIejW000AovG3gv9WaPZIjsEP/kXZIUV4DjZsVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiu Wenbo <qiuwenbo@kylinos.com.cn>,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 008/127] platform/x86: ideapad-laptop: fix a NULL pointer dereference
Date:   Mon, 24 May 2021 17:25:25 +0200
Message-Id: <20210524152335.139344613@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiu Wenbo <qiuwenbo@kylinos.com.cn>

[ Upstream commit ff67dbd554b2aaa22be933eced32610ff90209dd ]

The third parameter of dytc_cql_command should not be NULL since it will
be dereferenced immediately.

Fixes: ff36b0d953dc4 ("platform/x86: ideapad-laptop: rework and create new ACPI helpers")
Signed-off-by: Qiu Wenbo <qiuwenbo@kylinos.com.cn>
Acked-by: Ike Panhc <ike.pan@canonical.com>
Link: https://lore.kernel.org/r/20210428050636.8003-1-qiuwenbo@kylinos.com.cn
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6cb5ad4be231..8f871151f0cc 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -809,6 +809,7 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 {
 	struct ideapad_dytc_priv *dytc = container_of(pprof, struct ideapad_dytc_priv, pprof);
 	struct ideapad_private *priv = dytc->priv;
+	unsigned long output;
 	int err;
 
 	err = mutex_lock_interruptible(&dytc->mutex);
@@ -829,7 +830,7 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 
 		/* Determine if we are in CQL mode. This alters the commands we do */
 		err = dytc_cql_command(priv, DYTC_SET_COMMAND(DYTC_FUNCTION_MMC, perfmode, 1),
-				       NULL);
+				       &output);
 		if (err)
 			goto unlock;
 	}
-- 
2.30.2



