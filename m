Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30799B5CD1
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfIRGZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbfIRGZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00F5218AF;
        Wed, 18 Sep 2019 06:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787909;
        bh=nerxgIB4K0RwEScMkf7xs5pEABsAo/UmUQ5hGfz4X2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kc0/f0v4mphxWXr/HoqQEW18rdZLVXf5HAiJ08UpsBZa61Zt3N+9eEslkBDqLFoKg
         4Ov8As+XLAdYqM+Rt/0BlD6za+6VfD48sezlAbqpwaJUNR8ZS9BgtuE3yD8/16LLTH
         oKaQ86dJYxiAnqhEK1CpiyVzm+ntAVK6R1s+9ayo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 28/85] Revert "mmc: bcm2835: Terminate timeout work synchronously"
Date:   Wed, 18 Sep 2019 08:18:46 +0200
Message-Id: <20190918061235.046409098@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

commit aea64b583601aa5e0d6ea51a0420e46e43710bd4 upstream.

The commit 37fefadee8bb ("mmc: bcm2835: Terminate timeout work
synchronously") causes lockups in case of hardware timeouts due the
timeout work also calling cancel_delayed_work_sync() on its own.
So revert it.

Fixes: 37fefadee8bb ("mmc: bcm2835: Terminate timeout work synchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/bcm2835.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/bcm2835.c
+++ b/drivers/mmc/host/bcm2835.c
@@ -597,7 +597,7 @@ static void bcm2835_finish_request(struc
 	struct dma_chan *terminate_chan = NULL;
 	struct mmc_request *mrq;
 
-	cancel_delayed_work_sync(&host->timeout_work);
+	cancel_delayed_work(&host->timeout_work);
 
 	mrq = host->mrq;
 


