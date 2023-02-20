Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55F069CD0C
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjBTNqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjBTNqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA81DB91
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 721B8CE0F6D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810BBC433D2;
        Mon, 20 Feb 2023 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900725;
        bh=jQP7BxnVaLgI/6Mijp0elsquB5wu9UYrExEs8T4R9M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdPC+DUJoxE+viOAXYILmaY+w2CfYNcPR6xskjBNL406AbnbD10wr8O1OgEwKtPNF
         NML2ZnMIwCl5ezei5iM6JAUzR/YnVylKAZ4Vg3p8jgRMPQuF7uLApf2LYG7+gclJ7C
         kaX8rdtg7zw3zNiSc0+AyW7YZAxPNuqdFNbuDpFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marius Dinu <marius@psihoexpert.ro>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/156] ata: libata: Fix sata_down_spd_limit() when no link speed is reported
Date:   Mon, 20 Feb 2023 14:34:19 +0100
Message-Id: <20230220133603.099014427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 69f2c9346313ba3d3dfa4091ff99df26c67c9021 ]

Commit 2dc0b46b5ea3 ("libata: sata_down_spd_limit should return if
driver has not recorded sstatus speed") changed the behavior of
sata_down_spd_limit() to return doing nothing if a drive does not report
a current link speed, to avoid reducing the link speed to the lowest 1.5
Gbps speed.

However, the change assumed that a speed was recorded before probing
(e.g. before a suspend/resume) and set in link->sata_spd. This causes
problems with adapters/drives combination failing to establish a link
speed during probe autonegotiation. One example reported of this problem
is an mvebu adapter with a 3Gbps port-multiplier box: autonegotiation
fails, leaving no recorded link speed and no reported current link
speed. Probe retries also fail as no action is taken by sata_set_spd()
after each retry.

Fix this by returning early in sata_down_spd_limit() only if we do have
a recorded link speed, that is, if link->sata_spd is not 0. With this
fix, a failed probe not leading to a recorded link speed is retried at
the lower 1.5 Gbps speed, with the link speed potentially increased
later on the second revalidate of the device if the device reports
that it supports higher link speeds.

Reported-by: Marius Dinu <marius@psihoexpert.ro>
Fixes: 2dc0b46b5ea3 ("libata: sata_down_spd_limit should return if driver has not recorded sstatus speed")
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Marius Dinu <marius@psihoexpert.ro>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fbb1676aa33f..c06f618b1aa3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3096,7 +3096,7 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 	 */
 	if (spd > 1)
 		mask &= (1 << (spd - 1)) - 1;
-	else
+	else if (link->sata_spd)
 		return -EINVAL;
 
 	/* were we already at the bottom? */
-- 
2.39.0



