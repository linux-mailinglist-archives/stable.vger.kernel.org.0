Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1818218100
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgGHHVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgGHHVv (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:21:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C655206E2;
        Wed,  8 Jul 2020 07:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192910;
        bh=AlWh1K+4UB1dCOl88PhWodG1vGihddUyYMFznHgyj98=;
        h=Subject:To:From:Date:From;
        b=GiGENFeHbXCcO41sI+WptIVGCHtnfkToxbR4JU8imAafd48g+tMPJu3XiDqmjLE+r
         K4/m3TnBtTN3V7jQBqYhNnrqv4/cpxlNXNuEW+mXY2QpQjzyUS8wylqOlAzJ8QXVsp
         kZZ0XN7pkksEzTgw5j/1nzCJxAWnWy5bgFJ92CWM=
Subject: patch "iio: pressure: zpa2326: handle pm_runtime_get_sync failure" added to staging-linus
To:     navid.emamdoost@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jul 2020 09:21:30 +0200
Message-ID: <159419289019112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: pressure: zpa2326: handle pm_runtime_get_sync failure

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d88de040e1df38414fc1e4380be9d0e997ab4d58 Mon Sep 17 00:00:00 2001
From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Thu, 4 Jun 2020 21:44:44 -0500
Subject: iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Fixes: 03b262f2bbf4 ("iio:pressure: initial zpa2326 barometer support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/pressure/zpa2326.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index 37fe851f89af..799a8dc3e248 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -665,8 +665,10 @@ static int zpa2326_resume(const struct iio_dev *indio_dev)
 	int err;
 
 	err = pm_runtime_get_sync(indio_dev->dev.parent);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put(indio_dev->dev.parent);
 		return err;
+	}
 
 	if (err > 0) {
 		/*
-- 
2.27.0


