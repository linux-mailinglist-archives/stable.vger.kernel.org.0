Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACEC55E315
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiF0L25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbiF0L1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:27:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970949FF3;
        Mon, 27 Jun 2022 04:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3440C614A0;
        Mon, 27 Jun 2022 11:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AECEC3411D;
        Mon, 27 Jun 2022 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329232;
        bh=+PEY8aTgvCN7a4zjWSNtiwwqaicvZrFgs6faUOWbhog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJN3S667m4HBxOrhN/WQR7pm+9h9kTbtFGMUtYTaa6Fu8sHVZxkRfeAHe3aBRztvI
         KPslf1/iwurPB+OsipJCzJCz5UXz+EQwO/uJbNSj6lLSeqr4XU1raWXWtz1z6XZFTs
         eQip5IKJpAvquXotj0C1Br/8Ufk3FR0369dvNI9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 095/102] soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe
Date:   Mon, 27 Jun 2022 13:21:46 +0200
Message-Id: <20220627111936.285730063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 37d838de369b07b596c19ff3662bf0293fdb09ee upstream.

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

In brcmstb_init_sram, it pass dn to of_address_to_resource(),
of_address_to_resource() will call of_find_device_by_node() to take
reference, so we should release the reference returned by
of_find_matching_node().

Fixes: 0b741b8234c8 ("soc: bcm: brcmstb: Add support for S2/S3/S5 suspend states (ARM)")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/bcm/brcmstb/pm/pm-arm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -780,6 +780,7 @@ static int brcmstb_pm_probe(struct platf
 	}
 
 	ret = brcmstb_init_sram(dn);
+	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
 		return ret;


