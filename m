Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D01E2BFE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392030AbgEZTK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391949AbgEZTKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA676208B3;
        Tue, 26 May 2020 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520255;
        bh=aGSkKgSOvYQfQlZ2A9zyiq/PE8Y9abBefhMktsu3diI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM0EJboyb3wturfdTF+5urLfzlLs8yAFdYb5qZSalZO0MfKUSK8ibiOeOXKyde+z6
         xCOcHms38VVzoZXLmb9Y8OEBR5wMSB4N1NtE0k+/Jpx3cVkkCLUTu/XCd2RxUoF2/f
         AD+xdkw64IkNKWKsuiyCbiis+5+0jKjcasyIHGpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dijil Mohan <Dijil.Mohan@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 071/111] dmaengine: dmatest: Restore default for channel
Date:   Tue, 26 May 2020 20:53:29 +0200
Message-Id: <20200526183939.583066453@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

commit 6b41030fdc79086db5d673c5ed7169f3ee8c13b9 upstream.

In case of dmatest is built-in and no channel was configured test
doesn't run with:

dmatest: Could not start test, no channels configured

Even though description to "channel" parameter claims that default is
any.

Add default channel back as it used to be rather than reject test with
no channel configuration.

Fixes: d53513d5dc285d9a95a534fc41c5c08af6b60eac ("dmaengine: dmatest: Add support for multi channel testing)
Reported-by: Dijil Mohan <Dijil.Mohan@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Link: https://lore.kernel.org/r/20200429071522.58148-1-vladimir.murzin@arm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmatest.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -1166,10 +1166,11 @@ static int dmatest_run_set(const char *v
 		mutex_unlock(&info->lock);
 		return ret;
 	} else if (dmatest_run) {
-		if (is_threaded_test_pending(info))
-			start_threaded_tests(info);
-		else
-			pr_info("Could not start test, no channels configured\n");
+		if (!is_threaded_test_pending(info)) {
+			pr_info("No channels configured, continue with any\n");
+			add_threaded_test(info);
+		}
+		start_threaded_tests(info);
 	} else {
 		stop_threaded_test(info);
 	}


