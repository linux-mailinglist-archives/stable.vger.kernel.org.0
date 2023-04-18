Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9226E64C2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjDRMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjDRMwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E015516F86
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD86863433
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB80C4339C;
        Tue, 18 Apr 2023 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822299;
        bh=iSKRnCMXnp7Af6WCSWCtH/isYlOhKmZjT8VkxonZ5eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRVimu+JMVqp0q1MtBfop7V7YvS591Cx9VEbiXF1X4lnh8XrlkM4E9BE378LRMOCz
         48ojaVI2xw6tHkR6IAvjBsICVMwH3JZAtulg1oGcLLbB0eh5bTmzcfs/XX+HsjHfxC
         RSOII8AAre4vnvQ9S7w2bOPlv6RgyIT58JLNhsQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 070/139] selftests: openvswitch: adjust datapath NL message declaration
Date:   Tue, 18 Apr 2023 14:22:15 +0200
Message-Id: <20230418120316.440408027@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 306dc21361993f4fe50a15d4db6b1a4de5d0adb0 ]

The netlink message for creating a new datapath takes an array
of ports for the PID creation.  This shouldn't cause much issue
but correct it for future cases where we need to do decode of
datapath information that could include the per-cpu PID map.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/20230412115828.3991806-1-aconole@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 3243c90d449e6..5d467d1993cb1 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -62,7 +62,7 @@ class OvsDatapath(GenericNetlinkSocket):
         nla_map = (
             ("OVS_DP_ATTR_UNSPEC", "none"),
             ("OVS_DP_ATTR_NAME", "asciiz"),
-            ("OVS_DP_ATTR_UPCALL_PID", "uint32"),
+            ("OVS_DP_ATTR_UPCALL_PID", "array(uint32)"),
             ("OVS_DP_ATTR_STATS", "dpstats"),
             ("OVS_DP_ATTR_MEGAFLOW_STATS", "megaflowstats"),
             ("OVS_DP_ATTR_USER_FEATURES", "uint32"),
-- 
2.39.2



