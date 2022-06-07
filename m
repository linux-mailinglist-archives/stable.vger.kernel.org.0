Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21A9541DD5
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382317AbiFGWV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384597AbiFGWUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:20:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4361263DC6;
        Tue,  7 Jun 2022 12:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8AA2609FA;
        Tue,  7 Jun 2022 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51EEC385A2;
        Tue,  7 Jun 2022 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629641;
        bh=wgKRNI73T2zZGmaV8LU9D8Jm69k2YDtN51rVD4phD80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKi0NoQibCWq/4Oj96Ch4VdTfxrhQBPvsX8TdQ2xaLG+AGI6Bi0sOxKtVqrwTK9Mh
         +db9qwHJ6q18A4ou+jQCI2KqaQGtQ4xeqvojoSYUp5NjmOPLgj6OrsphJNcbp5F0T9
         tFBU2kJj6HZ6QcAJEG/O9UgJrlPfKnOIi9oSnVpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 5.18 723/879] iwlwifi: mei: fix potential NULL-ptr deref
Date:   Tue,  7 Jun 2022 19:04:01 +0200
Message-Id: <20220607165023.839965948@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 78488a64aea94a3336ee97f345c1496e9bc5ebdf upstream.

If SKB allocation fails, continue rather than using the NULL
pointer.

Coverity CID: 1497650

Cc: stable@vger.kernel.org
Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20220517120045.90c1b1fd534e.Ibb42463e74d0ec7d36ec81df22e171ae1f6268b0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1020,6 +1020,8 @@ static void iwl_mei_handle_sap_data(stru
 
 		/* We need enough room for the WiFi header + SNAP + IV */
 		skb = netdev_alloc_skb(netdev, len + QOS_HDR_IV_SNAP_LEN);
+		if (!skb)
+			continue;
 
 		skb_reserve(skb, QOS_HDR_IV_SNAP_LEN);
 		ethhdr = skb_push(skb, sizeof(*ethhdr));


