Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893BE4E2910
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348706AbiCUOBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348398AbiCUOAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255563585C;
        Mon, 21 Mar 2022 06:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE24B816DC;
        Mon, 21 Mar 2022 13:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A50C340E8;
        Mon, 21 Mar 2022 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871123;
        bh=z5b40hV7USiaybTi52DgQM4KYPVIVs5XmZFdjoSRWQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlQnZx7E5qHdS+15dRhZJp7Im+9SiuOqN/M1CgKW7U7ulzlHdmA7IabKw/Fvnk2EI
         5IIU3n/KRYGdJg3Fa+NaVOri0G6FcJxZULsAzh3v9u8RClIoD7ZduXQ8wAqZEZdNyT
         2E5EcDuk7jA7Ux9MiC68beQWZUK1Yo9kh3jlFPnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/30] net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()
Date:   Mon, 21 Mar 2022 14:52:43 +0100
Message-Id: <20220321133220.030602413@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 4ee06de7729d795773145692e246a06448b1eb7a ]

This kind of interface doesn't have a mac header. This patch fixes
bpf_redirect() to a PIM interface.

Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20220315092008.31423-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index bf5c5f32c65e..e147ea679467 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -51,6 +51,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
+	case ARPHRD_PIMREG:
 		return false;
 	default:
 		return true;
-- 
2.34.1



