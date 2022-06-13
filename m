Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2D549079
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357092AbiFMLwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356558AbiFMLup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E42657B;
        Mon, 13 Jun 2022 03:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8814960F9A;
        Mon, 13 Jun 2022 10:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91361C34114;
        Mon, 13 Jun 2022 10:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117661;
        bh=ix45NMYnhPTdqswFILcqFEMM4VRwxKhmL4d0TY9LdVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRn+ZeCBIhSvB4IuRiH/JA51OCI1j5Uxal4UpZbFIRKqTI/6TPwtXzmYm9PfLjFpH
         hwQAdSCGZ88CA2PF6rjaTOGcjLnx3ovKWgz8G81dzC5HE/GlbJavXT5UtcLIHPwbb3
         aLLBrXyBCwMnntSxFH7qpyO+EsH1/H2Myd/jlbYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 410/411] md/raid0: Ignore RAID0 layout if the second zone has only one device
Date:   Mon, 13 Jun 2022 12:11:23 +0200
Message-Id: <20220613094941.114865346@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Pascal Hambourg <pascal@plouf.fr.eu.org>

commit ea23994edc4169bd90d7a9b5908c6ccefd82fa40 upstream.

The RAID0 layout is irrelevant if all members have the same size so the
array has only one zone. It is *also* irrelevant if the array has two
zones and the second zone has only one device, for example if the array
has two members of different sizes.

So in that case it makes sense to allow assembly even when the layout is
undefined, like what is done when the array has only one zone.

Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid0.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -143,21 +143,6 @@ static int create_strip_zones(struct mdd
 	pr_debug("md/raid0:%s: FINAL %d zones\n",
 		 mdname(mddev), conf->nr_strip_zones);
 
-	if (conf->nr_strip_zones == 1) {
-		conf->layout = RAID0_ORIG_LAYOUT;
-	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
-		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = mddev->layout;
-	} else if (default_layout == RAID0_ORIG_LAYOUT ||
-		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = default_layout;
-	} else {
-		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
-		       mdname(mddev));
-		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
-		err = -ENOTSUPP;
-		goto abort;
-	}
 	/*
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
@@ -288,6 +273,22 @@ static int create_strip_zones(struct mdd
 			 (unsigned long long)smallest->sectors);
 	}
 
+	if (conf->nr_strip_zones == 1 || conf->strip_zone[1].nb_dev == 1) {
+		conf->layout = RAID0_ORIG_LAYOUT;
+	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
+		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = mddev->layout;
+	} else if (default_layout == RAID0_ORIG_LAYOUT ||
+		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = default_layout;
+	} else {
+		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
+		       mdname(mddev));
+		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
+		err = -EOPNOTSUPP;
+		goto abort;
+	}
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 


