Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B694956FB01
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiGKJZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiGKJYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2841529C9C;
        Mon, 11 Jul 2022 02:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E45610A5;
        Mon, 11 Jul 2022 09:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8836C34115;
        Mon, 11 Jul 2022 09:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530895;
        bh=LeO8Igb2hdh3kyMobdyRRQAuDTQtRfL4d/jaR8S1KFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVSlINmXDhswxpvSQvOxB9WHEyWhiw8EGroylLWJHhZCE9Gw3EDXjmlWN1UVE9Ez0
         695MJEvSD3Kjal+mwZULCzsM1z5SX/401gcoO6uSz66SNKsi6+1eDHIFZQKucsvbIP
         MakDK8LBD9imetP09gD845jXfk3l5jr4TDzzoC9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hugues ANGUELKOV <hanguelkov@randorisec.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.18 022/112] netfilter: nf_tables: stricter validation of element data
Date:   Mon, 11 Jul 2022 11:06:22 +0200
Message-Id: <20220711090550.189185714@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7e6bc1f6cabcd30aba0b11219d8e01b952eacbb6 upstream.

Make sure element data type and length do not mismatch the one specified
by the set declaration.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Reported-by: Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5213,13 +5213,20 @@ static int nft_setelem_parse_data(struct
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


