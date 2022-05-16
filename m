Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E70528E39
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345642AbiEPTj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345638AbiEPTix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:38:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F10C3EF3C;
        Mon, 16 May 2022 12:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C957B81607;
        Mon, 16 May 2022 19:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E800C385AA;
        Mon, 16 May 2022 19:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652729916;
        bh=10tgVETi0/0icrHOI5cWzODW+G7sx5Wwa+9DpVGgXQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmpElj9XCIRLsteH1iMptLvGHAjow00uLj3e0rVBkfjg7YdkvnnhdxCwBgyHs3hPe
         ahFXm4n8its7SzljdQCvrqdom60t3Ikrull4wLwuD3orubfVy0vYet9HF57TT4/LY9
         0Gr7DhP0Rxh0eHe29JGDPFpPv8KNWT9EAIAQqEuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/19] s390/ctcm: fix variable dereferenced before check
Date:   Mon, 16 May 2022 21:36:18 +0200
Message-Id: <20220516193613.657644555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
References: <20220516193613.497233635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 2c50c6867c85afee6f2b3bcbc50fc9d0083d1343 ]

Found by cppcheck and smatch.
smatch complains about
drivers/s390/net/ctcm_sysfs.c:43 ctcm_buffer_write() warn: variable dereferenced before check 'priv' (see line 42)

Fixes: 3c09e2647b5e ("ctcm: rename READ/WRITE defines to avoid redefinitions")
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ctcm_sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index ddb0aa321339..07b7177abf26 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -38,11 +38,12 @@ static ssize_t ctcm_buffer_write(struct device *dev,
 	struct ctcm_priv *priv = dev_get_drvdata(dev);
 	int rc;
 
-	ndev = priv->channel[CTCM_READ]->netdev;
-	if (!(priv && priv->channel[CTCM_READ] && ndev)) {
+	if (!(priv && priv->channel[CTCM_READ] &&
+	      priv->channel[CTCM_READ]->netdev)) {
 		CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
 		return -ENODEV;
 	}
+	ndev = priv->channel[CTCM_READ]->netdev;
 
 	rc = kstrtouint(buf, 0, &bs1);
 	if (rc)
-- 
2.35.1



