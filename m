Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75315010F0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiDNNhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245579AbiDNN3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61BEADD63;
        Thu, 14 Apr 2022 06:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30047B82983;
        Thu, 14 Apr 2022 13:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7362CC385A9;
        Thu, 14 Apr 2022 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942592;
        bh=sxBywIbmDzdEuccwtVSS+3Adnpc3kzgA4oswz3VyPA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7wsm4Ibt41+n6Mr3+83HYWon0aupu/4VxBFHOYHI8cMsvpJgq7VMVARLgWB7BNI2
         KWp2vT1w6JpWKaaNLSMFU7BROFIxqMYeYQIGOZawBUXmV6xC2ptwIuA8Vp40GDMZ46
         zog2SmhZoJQa+Isv30p5t4FOTEGmicbr6xbh8zPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/338] Fix incorrect type in assignment of ipv6 port for audit
Date:   Thu, 14 Apr 2022 15:11:33 +0200
Message-Id: <20220414110844.303746790@linuxfoundation.org>
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

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit a5cd1ab7ab679d252a6d2f483eee7d45ebf2040c ]

Remove inappropriate use of ntohs() and assign the
port value directly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 221de4c755c3..4f65d953fe31 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2586,7 +2586,7 @@ static int smk_ipv6_check(struct smack_known *subject,
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 	ad.a.u.net->family = PF_INET6;
-	ad.a.u.net->dport = ntohs(address->sin6_port);
+	ad.a.u.net->dport = address->sin6_port;
 	if (act == SMK_RECEIVING)
 		ad.a.u.net->v6info.saddr = address->sin6_addr;
 	else
-- 
2.34.1



