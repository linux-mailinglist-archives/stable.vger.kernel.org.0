Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD06F5CBE9
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfGBIC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfGBIC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DC5D216C8;
        Tue,  2 Jul 2019 08:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054575;
        bh=GNizRBeqQ6ROLVksye5/GoG1+koTGI2044OlJYwFIRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETX9aOg1yoJOXVcvzhT2PhY56zcZOshcIY76RP4eilX7L06JQ6O9/VF+LXtFGsEla
         YuBIzkTIVVaEhH8WhgB17cjAOkveE/enFiewv+Jo6tgCCoW2yyfxbOnnN7j+iYaQC9
         a0Eu4rVtOHlf2N9AGTTtzpgUL6w6EaGRkkR6LF8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 17/55] dm init: fix incorrect uses of kstrndup()
Date:   Tue,  2 Jul 2019 10:01:25 +0200
Message-Id: <20190702080124.938027622@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

commit dec7e6494e1aea6bf676223da3429cd17ce0af79 upstream.

Fix 2 kstrndup() calls with incorrect argument order.

Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org # v5.1
Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -140,8 +140,8 @@ static char __init *dm_parse_table_entry
 		return ERR_PTR(-EINVAL);
 	}
 	/* target_args */
-	dev->target_args_array[n] = kstrndup(field[3], GFP_KERNEL,
-					     DM_MAX_STR_SIZE);
+	dev->target_args_array[n] = kstrndup(field[3], DM_MAX_STR_SIZE,
+					     GFP_KERNEL);
 	if (!dev->target_args_array[n])
 		return ERR_PTR(-ENOMEM);
 
@@ -275,7 +275,7 @@ static int __init dm_init_init(void)
 		DMERR("Argument is too big. Limit is %d\n", DM_MAX_STR_SIZE);
 		return -EINVAL;
 	}
-	str = kstrndup(create, GFP_KERNEL, DM_MAX_STR_SIZE);
+	str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
 


