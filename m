Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F85528E56
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345944AbiEPTnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346201AbiEPTlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:41:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45883FDBB;
        Mon, 16 May 2022 12:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 360EACE176C;
        Mon, 16 May 2022 19:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A79C34100;
        Mon, 16 May 2022 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730017;
        bh=PzICwLjlQo99NgdyMEC1XtS6+gYXW+gJUuLaUJcbn10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G0ExOcwz7ofd0Z6TGYaLh+CP+GV2u/Iq2YxJJ66UBBPECXBxAHPFOXgBw0ajjRRD
         auzFil85ly6+GY7u2fKNmEFqoVizB+xj4NtsfExvRdIIO0Q3CV6ut228onta20qjld
         +KTIi9qA57TluUDwVREx+069MWCZs+MFevYHpXPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/25] s390/ctcm: fix variable dereferenced before check
Date:   Mon, 16 May 2022 21:36:21 +0200
Message-Id: <20220516193614.906869440@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
References: <20220516193614.678319286@linuxfoundation.org>
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
index ded1930a00b2..e3813a7aa5e6 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -39,11 +39,12 @@ static ssize_t ctcm_buffer_write(struct device *dev,
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



