Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47888500E9F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbiDNNT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243918AbiDNNSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E757CDFD;
        Thu, 14 Apr 2022 06:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5AC461374;
        Thu, 14 Apr 2022 13:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0902C385A1;
        Thu, 14 Apr 2022 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942169;
        bh=3+4nmWa7q7nSgldQDzkfqfKGl8LpWcHx9SlTod8lqUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt02QTrahhMQ3GWK/j7A1WGA4vyCOMNZJo4y4StFUgCAJdFC4qEWDaF2wom9jcLPA
         4A1fKIg5IgYCCP5sAkm102H8VgE1ThiUbTU5DW6H+sHBZ6xqH8FNoQxUzJCcCmj+Vt
         oDE9ic0vb79tggg9Dh/U4GCXDTU0QeO1KNz/evDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 040/338] qed: display VF trust config
Date:   Thu, 14 Apr 2022 15:09:03 +0200
Message-Id: <20220414110840.037528401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

commit 4e6e6bec7440b9b76f312f28b1f4e944eebb3abc upstream.

Driver does support SR-IOV VFs trust configuration but
it does not display it when queried via ip link utility.

Cc: stable@vger.kernel.org
Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4709,6 +4709,7 @@ static int qed_get_vf_config(struct qed_
 	tx_rate = vf_info->tx_rate;
 	ivi->max_tx_rate = tx_rate ? tx_rate : link.speed;
 	ivi->min_tx_rate = qed_iov_get_vf_min_rate(hwfn, vf_id);
+	ivi->trusted = vf_info->is_trusted_request;
 
 	return 0;
 }


