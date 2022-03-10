Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE3F4D4BDA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244150AbiCJOc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343929AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2289BC6202;
        Thu, 10 Mar 2022 06:28:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B094A61B18;
        Thu, 10 Mar 2022 14:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCF2C340E8;
        Thu, 10 Mar 2022 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922520;
        bh=mMFJq8Ko56zaJHI38hia/81FMs/sNfXgCDsycpM+DBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4Wp6ADSvRoqqJXM38lLbeJ4aTEYEyVzlcCYSjCbmODEB0H7+X4eDkmS0927obbui
         wY+jm7gq1mo1zQllaRPOgfAoJujqPfyluv3S/+RGoEIMj3UdOJOBIZDP4BadlkeDBM
         PAPAOP2E3S7JhxgsZBmTV/v/lCMJUfeiPJIjB6O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 25/33] xen/netfront: dont use gnttab_query_foreign_access() for mapped status
Date:   Thu, 10 Mar 2022 15:19:26 +0100
Message-Id: <20220310140809.478597046@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit 31185df7e2b1d2fa1de4900247a12d7b9c7087eb upstream.

It isn't enough to check whether a grant is still being in use by
calling gnttab_query_foreign_access(), as a mapping could be realized
by the other side just after having called that function.

In case the call was done in preparation of revoking a grant it is
better to do so via gnttab_end_foreign_access_ref() and check the
success of that operation instead.

This is CVE-2022-23037 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -412,14 +412,12 @@ static bool xennet_tx_buf_gc(struct netf
 			queue->tx_link[id] = TX_LINK_NONE;
 			skb = queue->tx_skbs[id];
 			queue->tx_skbs[id] = NULL;
-			if (unlikely(gnttab_query_foreign_access(
-				queue->grant_tx_ref[id]) != 0)) {
+			if (unlikely(!gnttab_end_foreign_access_ref(
+				queue->grant_tx_ref[id], GNTMAP_readonly))) {
 				dev_alert(dev,
 					  "Grant still in use by backend domain\n");
 				goto err;
 			}
-			gnttab_end_foreign_access_ref(
-				queue->grant_tx_ref[id], GNTMAP_readonly);
 			gnttab_release_grant_reference(
 				&queue->gref_tx_head, queue->grant_tx_ref[id]);
 			queue->grant_tx_ref[id] = GRANT_INVALID_REF;


