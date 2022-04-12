Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7383A4FD00A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbiDLGlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350193AbiDLGk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2371DF1B;
        Mon, 11 Apr 2022 23:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D3046189D;
        Tue, 12 Apr 2022 06:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD9C385A1;
        Tue, 12 Apr 2022 06:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745340;
        bh=hSs9leFkcxgo7zIL5+hzAKeXk3u0O/fjZFZTJGdTqDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrgFeQ1sDr3TFSrdpowLfpX8BHIYCHPDjaDqDmgWSqorYCY2g0EAByp9Jfx1G93oM
         9BcMqRb1y3GljTJfNQYxzqYRFcZrKf1pHCN9DWnAqyjtC9oW5xaoZ3wXDaudWCf6bD
         rIlGPgX8JJ4IDBZ343sYy59ERMNl7MEMwBxLqtn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shuklin <george.shuklin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/171] net: limit altnames to 64k total
Date:   Tue, 12 Apr 2022 08:29:13 +0200
Message-Id: <20220412062929.678145059@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 155fb43b70b5fce341347a77d1af2765d1e8fbb8 ]

Property list (altname is a link "property") is wrapped
in a nlattr. nlattrs length is 16bit so practically
speaking the list of properties can't be longer than
that, otherwise user space would have to interpret
broken netlink messages.

Prevent the problem from occurring by checking the length
of the property list before adding new entries.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 77b3d9cc08a1..873081cda950 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3626,12 +3626,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 			   bool *changed, struct netlink_ext_ack *extack)
 {
 	char *alt_ifname;
+	size_t size;
 	int err;
 
 	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
 	if (err)
 		return err;
 
+	if (cmd == RTM_NEWLINKPROP) {
+		size = rtnl_prop_list_size(dev);
+		size += nla_total_size(ALTIFNAMSIZ);
+		if (size >= U16_MAX) {
+			NL_SET_ERR_MSG(extack,
+				       "effective property list too long");
+			return -EINVAL;
+		}
+	}
+
 	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
-- 
2.35.1



