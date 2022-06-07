Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D0254160B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376315AbiFGUou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376275AbiFGUnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BF31F1BEA;
        Tue,  7 Jun 2022 11:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A0B7B82182;
        Tue,  7 Jun 2022 18:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A5BC385A2;
        Tue,  7 Jun 2022 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627119;
        bh=wgKRNI73T2zZGmaV8LU9D8Jm69k2YDtN51rVD4phD80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJ43Y8DizaRUh9SXNdRbZwokRNJ5b/tVF4on/sVQcxdBIEdYQcUArC+hVPLZaMBbH
         3Ab4INGmV9PnEduPhxdh7O4xoi+tVDktcqvv9IcPgWs6xO6W9v36j0naUDLQLaowb3
         laLeIIKdJVCBriVlXz7iE6pcntCtmf864dYmknlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 5.17 624/772] iwlwifi: mei: fix potential NULL-ptr deref
Date:   Tue,  7 Jun 2022 19:03:36 +0200
Message-Id: <20220607165007.323818841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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


