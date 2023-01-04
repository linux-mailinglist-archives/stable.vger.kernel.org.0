Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE465D82F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbjADQMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbjADQLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:11:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91481FF0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222696179A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DDFC433EF;
        Wed,  4 Jan 2023 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848680;
        bh=ZRfaL7B1q+besPeKnB4ITfS7CBQQvTa5vhZwqwqJgVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/7jAU/NxYfdcGwgvq5tv7beyYb+DTM1UnL0uLjjIv70mnBDQhTBevcXvgHo30syP
         pCScJhlC3X7hQ7+bg8XGFQOO1Omp3T8QpcDyXrCBSqEbhwg1Au850W8FjQPH21Xss6
         SXTv6rsaicToc1MqOOOv3PQtYs7+puN85SpOAK2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 062/207] mptcp: netlink: fix some error return code
Date:   Wed,  4 Jan 2023 17:05:20 +0100
Message-Id: <20230104160513.889246031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit e0fe1123ab2b07d2cd5475660bd0b4e6993ffaa7 upstream.

Fix to return negative error code -EINVAL from some error handling
case instead of 0, as done elsewhere in those functions.

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -156,6 +156,7 @@ int mptcp_nl_cmd_announce(struct sk_buff
 
 	if (addr_val.addr.id == 0 || !(addr_val.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
 		GENL_SET_ERR_MSG(info, "invalid addr id or flags");
+		err = -EINVAL;
 		goto announce_err;
 	}
 
@@ -282,6 +283,7 @@ int mptcp_nl_cmd_sf_create(struct sk_buf
 
 	if (addr_l.id == 0) {
 		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "missing local addr id");
+		err = -EINVAL;
 		goto create_err;
 	}
 
@@ -395,11 +397,13 @@ int mptcp_nl_cmd_sf_destroy(struct sk_bu
 
 	if (addr_l.family != addr_r.family) {
 		GENL_SET_ERR_MSG(info, "address families do not match");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
 	if (!addr_l.port || !addr_r.port) {
 		GENL_SET_ERR_MSG(info, "missing local or remote port");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 


