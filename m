Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033CF4CF9BA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiCGKND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbiCGKLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7506188B24;
        Mon,  7 Mar 2022 01:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 040A7CE0DF4;
        Mon,  7 Mar 2022 09:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23C1C340F3;
        Mon,  7 Mar 2022 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646851;
        bh=3O7SKRQEdlC3yZRHIUkedYLvoKSYVX7m7c9iwfV19E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg1wz6NsVC5uM7fzC82T+IhxkDm7b4z+XK6OSKCAw3Gdw3uSAoutNBmsURXlTG9Gf
         A44nA1hmaky180RnclufvLgsHw+dL/zWskr0jeAdaUu0xirfVejfnknS9OV3UD207e
         ZUCYbOt9gpa9rRCh3pqRG8/R05qv4zQKWBMEp0CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 115/186] ibmvnic: free reset-work-item when flushing
Date:   Mon,  7 Mar 2022 10:19:13 +0100
Message-Id: <20220307091657.293586677@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit 8d0657f39f487d904fca713e0bc39c2707382553 upstream.

Fix a tiny memory leak when flushing the reset work queue.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2780,8 +2780,10 @@ static int ibmvnic_reset(struct ibmvnic_
 	 * flush reset queue and process this reset
 	 */
 	if (adapter->force_reset_recovery && !list_empty(&adapter->rwi_list)) {
-		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list)
+		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
 			list_del(entry);
+			kfree(list_entry(entry, struct ibmvnic_rwi, list));
+		}
 	}
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);


