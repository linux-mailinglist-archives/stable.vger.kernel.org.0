Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C7522649B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgGTPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729625AbgGTPq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530CC22482;
        Mon, 20 Jul 2020 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259988;
        bh=dtljTeKVSfatOxCZOCNo1VmNsXnDxfFan/3oV9vWIzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyXooLe5FF09W2zrsqijYLTA6JZF4v/+tM9FpMqr5IPkvr1i3Scejlbp5eU6xqiF0
         njU8vV56OjVZiPPg08HlexVpZvz4dL7+IpvFQM6qOZNi6HCZo+UoZ2ZbhA72ZoZPJn
         E2Tc1AAUv3mj6ZmOmhkq1r00XNCrbqj1OqEAOtuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 066/125] iio: pressure: zpa2326: handle pm_runtime_get_sync failure
Date:   Mon, 20 Jul 2020 17:36:45 +0200
Message-Id: <20200720152806.211122812@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit d88de040e1df38414fc1e4380be9d0e997ab4d58 upstream.

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Fixes: 03b262f2bbf4 ("iio:pressure: initial zpa2326 barometer support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/pressure/zpa2326.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -672,8 +672,10 @@ static int zpa2326_resume(const struct i
 	int err;
 
 	err = pm_runtime_get_sync(indio_dev->dev.parent);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put(indio_dev->dev.parent);
 		return err;
+	}
 
 	if (err > 0) {
 		/*


