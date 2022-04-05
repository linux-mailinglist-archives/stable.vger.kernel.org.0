Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED0E4F3749
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352683AbiDELMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348937AbiDEJst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1AEA5E91;
        Tue,  5 Apr 2022 02:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D35F61577;
        Tue,  5 Apr 2022 09:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A882C385A2;
        Tue,  5 Apr 2022 09:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151485;
        bh=61JOj3rc2LxFRa0F8Npl5jgFEtUFrS1lDJOqF8od3/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhKl8SfBhNf3rFGy1hxqU1wCCIqJ5f5g3mfoKorYajGaB8UpxcpEWcOURKzbuTRZr
         GFpnx3kJ/hR4RxssTHo26q+YSO3eb98FLiBvwNOt6QC+KsqUixmZgqIRkTAj2oYtQ6
         lTQNEQiZRHa+lhxLHiyMUfKFJDiu/2njZIqCaEnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bracht Laumann Jespersen <t@laumann.xyz>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/913] scripts/dtc: Call pkg-config POSIXly correct
Date:   Tue,  5 Apr 2022 09:24:54 +0200
Message-Id: <20220405070352.794576865@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Thomas Bracht Laumann Jespersen <t@laumann.xyz>

[ Upstream commit a8b309ce9760943486e0585285e0125588a31650 ]

Running with POSIXLY_CORRECT=1 in the environment the scripts/dtc build
fails, because pkg-config doesn't output anything when the flags come
after the arguments.

Fixes: 067c650c456e ("dtc: Use pkg-config to locate libyaml")
Signed-off-by: Thomas Bracht Laumann Jespersen <t@laumann.xyz>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220131112028.7907-1-t@laumann.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 95aaf7431bff..1cba78e1dce6 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -29,7 +29,7 @@ dtc-objs	+= yamltree.o
 # To include <yaml.h> installed in a non-default path
 HOSTCFLAGS_yamltree.o := $(shell pkg-config --cflags yaml-0.1)
 # To link libyaml installed in a non-default path
-HOSTLDLIBS_dtc	:= $(shell pkg-config yaml-0.1 --libs)
+HOSTLDLIBS_dtc	:= $(shell pkg-config --libs yaml-0.1)
 endif
 
 # Generated files need one more search path to include headers in source tree
-- 
2.34.1



