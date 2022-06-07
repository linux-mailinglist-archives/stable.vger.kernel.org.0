Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB19541C70
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358000AbiFGV7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382740AbiFGVvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB14227CFF;
        Tue,  7 Jun 2022 12:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B8D3B82182;
        Tue,  7 Jun 2022 19:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B2C34115;
        Tue,  7 Jun 2022 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628959;
        bh=fZ092IcvSUIN4gS+C79ycWxMkz1HT7br/u2yNYt1EfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihuZSHlkEEWyTUtD5b6NFqjvdLhSApoXjfurQ1LhIEDsTNjiNMjmQz8Ry7oMouGKk
         swAUmBFtfIMApZQK8HCgwYszSa+b/AkSMnFUkuIEJ5r8wqGen3MTljHxbJDkHRYnLe
         scCP5vftus8fxBGaOIq8DeN0AB8uD+DGp32CdqLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 501/879] platform/x86: intel_cht_int33fe: Set driver data
Date:   Tue,  7 Jun 2022 19:00:19 +0200
Message-Id: <20220607165017.416217287@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 3ce827bf9cfecaf2cbfd9a9d44f0db9f40882780 ]

Module removal fails because cht_int33fe_typec_remove()
tries to access driver data that does not exist. Fixing by
assigning the data at the end of probe.

Fixes: 915623a80b5a ("platform/x86: intel_cht_int33fe: Switch to DMI modalias based loading")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220519122103.78546-1-heikki.krogerus@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/chtwc_int33fe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel/chtwc_int33fe.c b/drivers/platform/x86/intel/chtwc_int33fe.c
index 0de509fbf020..c52ac23e2331 100644
--- a/drivers/platform/x86/intel/chtwc_int33fe.c
+++ b/drivers/platform/x86/intel/chtwc_int33fe.c
@@ -389,6 +389,8 @@ static int cht_int33fe_typec_probe(struct platform_device *pdev)
 		goto out_unregister_fusb302;
 	}
 
+	platform_set_drvdata(pdev, data);
+
 	return 0;
 
 out_unregister_fusb302:
-- 
2.35.1



