Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08A15946B1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiHOXAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbiHOW6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22A9113;
        Mon, 15 Aug 2022 12:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7018BB80EAD;
        Mon, 15 Aug 2022 19:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2013C433C1;
        Mon, 15 Aug 2022 19:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593434;
        bh=Thbq7Vj9En4L4hyNflAXitDCnMOycKUfIHdHJvYtZtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syKhYgVVZKHcpsls/ufn9l/ywnc9SLkwFM+tytaKl+nbNQ/9EmcksqFejL0wfcquv
         nLiuXnw2l8d9u2f4oclD2qMcTWpGwdwhA9gocaQAULC1P1GLy5azpT8Fdb0qpyBtj1
         a9rqWYOKnIQqJqOhFoXr5Zw76rZ0qjQopMlSby10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0267/1157] spi: Return deferred probe error when controller isnt yet available
Date:   Mon, 15 Aug 2022 19:53:43 +0200
Message-Id: <20220815180450.287995036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9c22ec4ac27bcc5a54dd406da168f403327a5b55 ]

If the controller is not available, it might be in the future and
we would like to re-probe the peripheral again. For that purpose
return deferred probe.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215993
Fixes: 87e59b36e5e2 ("spi: Support selection of the index of the ACPI Spi Resource before alloc")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220709212956.25530-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index ea09d1b42bf6..62aa3f062f3d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2398,7 +2398,7 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 
 				ctlr = acpi_spi_find_controller_by_adev(adev);
 				if (!ctlr)
-					return -ENODEV;
+					return -EPROBE_DEFER;
 
 				lookup->ctlr = ctlr;
 			}
-- 
2.35.1



