Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9604C7561
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbiB1Ryt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbiB1RwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F99291341;
        Mon, 28 Feb 2022 09:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0CD1B815BB;
        Mon, 28 Feb 2022 17:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1193EC340F0;
        Mon, 28 Feb 2022 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069970;
        bh=CddVVUFIMUYm1CX/7EsfuhiY7pLEr+i9IuKyrRICjow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ysxo7U4FQCGGD0Pt29KwH8CikcfINepXVdsoY1HXCLvfLYmpU2EksXLLhmU29nRri
         gEiVOdPQLLQ+30mTfcQBIj9yopSwp/uLF+YfEgYfzTNF+M88ZAbzgCg0WUZv8axagu
         phdwlvYhOTGoyyOMlyqfFg/e56Rj5qdZYkq3s/eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cris Forno <cforno12@outlook.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 077/139] ibmvnic: schedule failover only if vioctl fails
Date:   Mon, 28 Feb 2022 18:24:11 +0100
Message-Id: <20220228172355.825625607@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit 277f2bb14361790a70e4b3c649e794b75a91a597 upstream.

If client is unable to initiate a failover reset via H_VIOCTL hcall, then
it should schedule a failover reset as a last resort. Otherwise, there is
no need to do a last resort.

Fixes: 334c42414729 ("ibmvnic: improve failover sysfs entry")
Reported-by: Cris Forno <cforno12@outlook.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Link: https://lore.kernel.org/r/20220221210545.115283-1-drt@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5733,10 +5733,14 @@ static ssize_t failover_store(struct dev
 		   be64_to_cpu(session_token));
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
 				H_SESSION_ERR_DETECTED, session_token, 0, 0);
-	if (rc)
+	if (rc) {
 		netdev_err(netdev,
 			   "H_VIOCTL initiated failover failed, rc %ld\n",
 			   rc);
+		goto last_resort;
+	}
+
+	return count;
 
 last_resort:
 	netdev_dbg(netdev, "Trying to send CRQ_CMD, the last resort\n");


