Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8173956B86D
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiGHLZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237493AbiGHLZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:25:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5A9904D5
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCB962465
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE990C341C0;
        Fri,  8 Jul 2022 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279511;
        bh=4N0BMu1eFEUEZcJUKZq2WjJpXehtvw3OxaXFWVgA8N0=;
        h=Subject:To:Cc:From:Date:From;
        b=DOaX2ORDUwKsdnbgp0bGa7+TaYBtXc497ccAugzK61r3QXKQGSeW3w+XiRajjDCVy
         1ERx/4caEwXavocDJE7aPZSy8ypXA95yd6CPFvVoV0/Hb/Dsxa8G2GG7wxSkxLR+jK
         z2kqo1p7wX4tHI81Vi92Hw1dm2Y1YgUO/4Wo+jOM=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: stricter validation of element data" failed to apply to 4.19-stable tree
To:     pablo@netfilter.org, hanguelkov@randorisec.fr
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:25:00 +0200
Message-ID: <165727950068128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7e6bc1f6cabcd30aba0b11219d8e01b952eacbb6 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 2 Jul 2022 04:16:30 +0200
Subject: [PATCH] netfilter: nf_tables: stricter validation of element data

Make sure element data type and length do not mismatch the one specified
by the set declaration.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Reported-by: Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 51144fc66889..d6b59beab3a9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5213,13 +5213,20 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 				  struct nft_data *data,
 				  struct nlattr *attr)
 {
+	u32 dtype;
 	int err;
 
 	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
 	if (err < 0)
 		return err;
 
-	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+	if (set->dtype == NFT_DATA_VERDICT)
+		dtype = NFT_DATA_VERDICT;
+	else
+		dtype = NFT_DATA_VALUE;
+
+	if (dtype != desc->type ||
+	    set->dlen != desc->len) {
 		nft_data_release(data, desc->type);
 		return -EINVAL;
 	}

