Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32C4A54A4
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiBAB0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiBAB0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:26:52 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3930C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:26:52 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id i62so19332656ioa.1
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vnOvveDXbZQ696ndNfkx309VOYfA8JkTvF6R0cTPpB4=;
        b=hdvIfRVvFJUAbm0AFehFdDzXr/FiXhMW++UgUBX58QV+1zTq1DKZ7XErFa+b9nsqDY
         Qwlw9YJir1ic5ge2zBf62qcIf55c9TVMOgVTZIwzTAkR/xjmfBjLNiwnuEa4nI+cVpOl
         xGCUI2CfT1YlUz9pkUfSQM0tQ3myvsQ/kjvWJ8thm/TrN3WOC2pu5zeXFDy6LbH1qgdL
         HZGoC0/YEd6hex6DERtj/rIDweK5hU0iS/IP07qquoG/Zuj3rwA5ctrrK7LrQXIDwdSm
         Kj5MsnCWjZ+fDcYQYAwopg0g8al+rKSc+RPvrcHQp6+aLdwCGOmKqkIGmELwPTWQuP0E
         kOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vnOvveDXbZQ696ndNfkx309VOYfA8JkTvF6R0cTPpB4=;
        b=eN4VOgIePJgPcJCglepDrBnEauV04kMxJnx4jiLyu1LMyCOX3N5HzXS8aAnLDzCnUb
         5iXghl+MyRDh2rWSMHR/9xRkoJgXfNTHkQDY+cIT7igsoA0DlaisqUM6gC2VwKueoQzO
         B7leM0C7wO7HXMTod87JCuU7HKeOMDaaFTwEcrymPkYu13SPINHaI5BpAdNfY6NDbCxY
         Je0WvMOzHjSpUt6yyVONdOVqS7US7HY0Frma2KrLIg5Tj52YC2oYfaRqr03+yNiYnxAs
         N6MUsuEAIXmWlEjB5iuPDFqHtDOjR947i7kk3M69TCWxo8sjdgv52ukMiXHSLIrhcQMa
         Jkqg==
X-Gm-Message-State: AOAM531S7/da140Shju2SEc42awKu2pxBLUSoza4Z1Ufrulpi0g30vdD
        cLqucbHKfIFxMY5AbLuS5G24vLkTj9IFLxtj
X-Google-Smtp-Source: ABdhPJwa9X2EyUqDxruRxp9GmUfKOAW5X/2dgKYGQ83umjO+Gfvt1wpqB/WhvRJ4fLGcLBoh7YXisw==
X-Received: by 2002:a6b:6f09:: with SMTP id k9mr12645382ioc.61.1643678812003;
        Mon, 31 Jan 2022 17:26:52 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h3sm3582350ilj.81.2022.01.31.17.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:26:51 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, elder@kernel.org,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 1/1] net: ipa: fix atomic update in ipa_endpoint_replenish()
Date:   Mon, 31 Jan 2022 19:26:36 -0600
Message-Id: <20220201012636.308616-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    XXX commit 6c0e3b5ce94947b311348c367db9e11dcb2ccc93 upstream.

In ipa_endpoint_replenish(), if an error occurs when attempting to
replenish a receive buffer, we just quit and try again later.  In
that case we increment the backlog count to reflect that the attempt
was unsuccessful.  Then, if the add_one flag was true we increment
the backlog again.

This second increment is not included in the backlog local variable
though, and its value determines whether delayed work should be
scheduled.  This is a bug.

Fix this by determining whether 1 or 2 should be added to the
backlog before adding it in a atomic_add_return() call.

Reference: https://lore.kernel.org/stable/164303143324018@kroah.com
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ipa/ipa_endpoint.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a37aae00e128f..397323f9e5d64 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -918,10 +918,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, u32 count)
 
 try_again_later:
 	/* The last one didn't succeed, so fix the backlog */
-	backlog = atomic_inc_return(&endpoint->replenish_backlog);
-
-	if (count)
-		atomic_add(count, &endpoint->replenish_backlog);
+	backlog = atomic_add_return(count + 1, &endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even
-- 
2.32.0

