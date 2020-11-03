Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D62A57D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgKCUwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732076AbgKCUwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CB5223AC;
        Tue,  3 Nov 2020 20:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436740;
        bh=b0dAR0umO+WckNgHuYynvx8MxyEIPeShA4NK4UrepSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEONz4dD8B7c2KGXASFhiRW/MB2plA0DDgDyHIf4TuGXRKKgnZcZor+Py3v7GPIyN
         LzPzMtCwgNHB2EjfIYTM+dbCTRgSDEbPnNG674RmZvmsR1t7HvTA+pTuJEzkw4M7mW
         ZUKWVdkJQKhsQvlPt+ydb/29Ljtd0+6hX+1LmNTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.9 381/391] staging: fieldbus: anybuss: jump to correct label in an error path
Date:   Tue,  3 Nov 2020 21:37:12 +0100
Message-Id: <20201103203412.874572710@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

commit 7e97e4cbf30026b49b0145c3bfe06087958382c5 upstream.

In current code, controller_probe() misses to call ida_simple_remove()
in an error path. Jump to correct label to fix it.

Fixes: 17614978ed34 ("staging: fieldbus: anybus-s: support the Arcx anybus controller")
Reviewed-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201012132404.113031-1-jingxiangfeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/fieldbus/anybuss/arcx-anybus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/fieldbus/anybuss/arcx-anybus.c
+++ b/drivers/staging/fieldbus/anybuss/arcx-anybus.c
@@ -293,7 +293,7 @@ static int controller_probe(struct platf
 	regulator = devm_regulator_register(dev, &can_power_desc, &config);
 	if (IS_ERR(regulator)) {
 		err = PTR_ERR(regulator);
-		goto out_reset;
+		goto out_ida;
 	}
 	/* make controller info visible to userspace */
 	cd->class_dev = kzalloc(sizeof(*cd->class_dev), GFP_KERNEL);


