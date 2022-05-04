Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142C51A996
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356626AbiEDRSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357042AbiEDROp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B07653E32;
        Wed,  4 May 2022 09:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 86278CE28AD;
        Wed,  4 May 2022 16:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B889EC385AA;
        Wed,  4 May 2022 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683478;
        bh=jzTDHvzUt0+FK1GCavcbHjEPmG6peMf7tUCHzlPx87o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7JSNgphiT42PL/67mkslWNgPtNEQ5LhxoSGv7itkLxaSo+uHT9AtKXsXqFtMdquy
         jtd5qdtRrKd+P8nhN1ue0MX23ZmCG8CFbH/G3y/45oje9BkOPSoshYaacurc4bm4px
         9Szpt0Ictm5zP8bAza7/MfqkE+KjAP0PCJcxBsQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 140/225] netfilter: conntrack: fix udp offload timeout sysctl
Date:   Wed,  4 May 2022 18:46:18 +0200
Message-Id: <20220504153122.718432261@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>

[ Upstream commit 626873c446f7559d5af8b48cefad903ffd85cf4e ]

`nf_flowtable_udp_timeout` sysctl option is available only
if CONFIG_NFT_FLOW_OFFLOAD enabled. But infra for this flow
offload UDP timeout was added under CONFIG_NF_FLOW_TABLE
config option. So, if you have CONFIG_NFT_FLOW_OFFLOAD
disabled and CONFIG_NF_FLOW_TABLE enabled, the
`nf_flowtable_udp_timeout` is not present in sysfs.
Please note, that TCP flow offload timeout sysctl option
is present even CONFIG_NFT_FLOW_OFFLOAD is disabled.

I suppose it was a typo in commit that adds UDP flow offload
timeout and CONFIG_NF_FLOW_TABLE should be used instead.

Fixes: 975c57504da1 ("netfilter: conntrack: Introduce udp offload timeout configuration")
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..55aa55b252b2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -823,7 +823,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
 		.procname	= "nf_flowtable_udp_timeout",
 		.maxlen		= sizeof(unsigned int),
-- 
2.35.1



