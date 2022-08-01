Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7458697B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiHAMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiHAMAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:00:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E306B4F655;
        Mon,  1 Aug 2022 04:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 794F9B80E8F;
        Mon,  1 Aug 2022 11:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4470C433C1;
        Mon,  1 Aug 2022 11:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354792;
        bh=A4HOruPbbaKVIxq1nerFl1jW8NyTpVY694MfOQPQpO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Puob3fpMNznZXy07aSZuk5YC5OWnIdEcUVqeZLJJ1jTBgQ05R3KMfVjrUIcXbd1LI
         5DdD2LMbtJKJh+xt7Va9dhwYj7xpqsN0WMqYAqfvEHje5PKfF1W6FbgIq49dzzloBJ
         qpGWNsfLrHXox6mi13BqFJtSgEn84W6QEOD3HqN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Liang He <windhl@126.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 22/69] scsi: ufs: host: Hold reference returned by of_parse_phandle()
Date:   Mon,  1 Aug 2022 13:46:46 +0200
Message-Id: <20220801114135.418190782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

commit a3435afba87dc6cd83f5595e7607f3c40f93ef01 upstream.

In ufshcd_populate_vreg(), we should hold the reference returned by
of_parse_phandle() and then use it to call of_node_put() for refcount
balance.

Link: https://lore.kernel.org/r/20220719071529.1081166-1-windhl@126.com
Fixes: aa4976130934 ("ufs: Add regulator enable support")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -107,9 +107,20 @@ out:
 	return ret;
 }
 
+static bool phandle_exists(const struct device_node *np,
+			   const char *phandle_name, int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+
+	if (parse_np)
+		of_node_put(parse_np);
+
+	return parse_np != NULL;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
-		struct ufs_vreg **out_vreg)
+				struct ufs_vreg **out_vreg)
 {
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
@@ -121,7 +132,7 @@ static int ufshcd_populate_vreg(struct d
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!phandle_exists(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;


