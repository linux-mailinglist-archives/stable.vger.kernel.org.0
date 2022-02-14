Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D304B46D7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245238AbiBNJrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiBNJqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A5365835;
        Mon, 14 Feb 2022 01:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D58AD60F87;
        Mon, 14 Feb 2022 09:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B440C340E9;
        Mon, 14 Feb 2022 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831566;
        bh=UAB7gaH3NgMrAcDUBNS5Abh/HcDIdCVCCYEvBt09frA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8qeWSCdW47RQq8EyDndLkns7oE6a34OP9ER2YgwQf6uGCSFy01eUapnSRY6Xi2u+
         2KhIcxfKg0e5nx4ODuBcEPCNGpT/JxdaurMAV9yP4ZIPq56zGRkEpkllwq+Sx/VJlK
         2r6mjy8jHc0RpPVmYRYdkXIZtN/FRK8df+yfWeOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Nogueira <victor@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/116] net: sched: Clarify error message when qdisc kind is unknown
Date:   Mon, 14 Feb 2022 10:25:22 +0100
Message-Id: <20220214092459.484974538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 973bf8fdd12f0e70ea351c018e68edd377a836d1 ]

When adding a tc rule with a qdisc kind that is not supported or not
compiled into the kernel, the kernel emits the following error: "Error:
Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
compiled in and it was not obvious right away what the message meant
without looking at the kernel code.

Change the error message to be more explicit and say the qdisc kind is
unknown.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 7b24582a8a164..6758968e79327 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1204,7 +1204,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1



