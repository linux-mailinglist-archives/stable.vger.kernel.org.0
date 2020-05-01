Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014261C1478
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgEANjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbgEANjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DD8208DB;
        Fri,  1 May 2020 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340383;
        bh=xsIm47QT/PkC5BM6zlFzzxen0zJsZueoPhnmIWEltf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFFOKj5vEshfPIwEhaOfnUAI/FrU76JHtq7E6D9HA65khzddhQHKmIwMOIdxYULeW
         aXDL7odaOvVzd3pgdey6NUEgibmBMzKM+KR178+gRA901JN7iuJLG2G51YViiPdW5E
         xj66FUvmb75qSeNNpRebtG3v8oVQfLECYWdUdMkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 44/83] PM: sleep: core: Switch back to async_schedule_dev()
Date:   Fri,  1 May 2020 15:23:23 +0200
Message-Id: <20200501131536.577666747@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 09beebd8f93b3c8bf894e342f0a203a5c612478c upstream.

Commit 8b9ec6b73277 ("PM core: Use new async_schedule_dev command")
introduced a new function for better performance.

However commit f2a424f6c613 ("PM / core: Introduce dpm_async_fn()
helper") went back to the non-optimized version, async_schedule().

So switch back to the sync_schedule_dev() to improve performance

Fixes: f2a424f6c613 ("PM / core: Introduce dpm_async_fn() helper")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -726,7 +726,7 @@ static bool dpm_async_fn(struct device *
 
 	if (is_async(dev)) {
 		get_device(dev);
-		async_schedule(func, dev);
+		async_schedule_dev(func, dev);
 		return true;
 	}
 


